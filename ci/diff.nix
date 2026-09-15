let
  data = builtins.fromJSON (builtins.readFile ./diff.json);

  config = {
    status = {
      Added = {
        color = "green";
        marker = "A.";
      };

      Removed = {
        color = "red";
        marker = "R.";
      };

      Upgraded = {
        color = "green";
        marker = "U.";
      };

      Downgraded = {
        color = "red";
        marker = "D.";
      };

      Changed = {
        color = "Goldenrod";
        marker = "C.";
      };
    };

    units = [
      {
        suffix = "GiB";
        size = 1024 * 1024 * 1024;
      }
      {
        suffix = "MiB";
        size = 1024 * 1024;
      }
      {
        suffix = "KiB";
        size = 1024;
      }
      {
        suffix = "B";
        size = 1;
      }
    ];
  };

  format = {
    bytes =
      signed: bytes:
      let
        abs = if bytes > 0 then bytes else -bytes;
        sign =
          if !signed then
            ""
          else if bytes > 0 then
            "+"
          else if bytes < 0 then
            "–"
          else
            "";

        unit = builtins.head (builtins.filter (unit: (abs + 1) >= unit.size) config.units);

        scaled = (abs * 100 + unit.size / 2) / unit.size;
        integer = scaled / 100;
        fraction =
          let
            decimal = scaled - integer * 100;
          in
          if decimal < 10 then "0${toString decimal}" else toString decimal;
      in
      sign + "${toString integer}.${fraction}" + unit.suffix;

    version =
      version:
      let
        amount = version.amount or 1;
      in
      version.name + (if amount == 1 then "" else "×${toString amount}");

    versions =
      versions:
      builtins.map (
        v:
        {
          changed = {
            old = format.version v.old;
            new = format.version v.new;
          };
          added = {
            old = null;
            new = format.version v.version;
          };
          removed = {
            old = format.version v.version;
            new = null;
          };
          amount_changed = {
            old = v.version.name + "×${toString v.old_amount}";
            new = v.version.name + "×${toString v.new_amount}";
          };
        }
        .${v.kind} or (throw "Unknown version kind: ${v.kind}")
      ) versions;
  };

  diffLine =
    {
      name,
      color,
      marker,
      oldVersions ? [ ],
      newVersions ? [ ],
      omitted ? false,
      delta,
    }:
    let
      applyColor = color: string: ''{\color{${color}}${string}}'';
      joinVersions = color: versions: builtins.concatStringsSep ", " (map (applyColor color) versions);

      render =
        text:
        let
          unchanged = applyColor "gray" "unchanged";
        in
        if omitted && text != "" then
          "${text}, ${unchanged}"
        else if omitted then
          unchanged
        else
          text;

      versionsText =
        let
          oldText = joinVersions "red" oldVersions;
          newText = joinVersions "green" newVersions;
        in
        if oldText == "" then
          render newText
        else if newText == "" then
          render oldText
        else
          (render oldText) + " → " + (render newText);

      sizeText =
        if delta == 0 then
          ""
        else
          applyColor (if delta < 0 then "blue" else "orange") (format.bytes true delta);

      renderedVersionsText = builtins.concatStringsSep ", " (
        builtins.filter (s: s != "") [
          versionsText
          sizeText
        ]
      );
    in
    ''&\text{[${applyColor color marker}] ${name}}\ &&\text{${renderedVersionsText}}\\'';

  makeLine =
    diff:
    let
      versions = format.versions diff.versions;
      oldVersions = builtins.map (v: v.old) (builtins.filter (v: v.old != null) versions);
      newVersions = builtins.map (v: v.new) (builtins.filter (v: v.new != null) versions);
    in
    diffLine (
      {
        inherit (diff) name;
        inherit oldVersions newVersions;
        omitted = diff.has_omitted_versions;
        delta = diff.size_delta;
      }
      // config.status.${diff.status}
    );

  added = builtins.filter (d: d.status == "Added") data.diffs;
  removed = builtins.filter (d: d.status == "Removed") data.diffs;
  changed = builtins.filter (
    d:
    builtins.elem d.status [
      "Upgraded"
      "Downgraded"
      "Changed"
    ]
  ) data.diffs;

  section =
    name: diffs:
    if diffs == [ ] then
      ""
    else
      builtins.concatStringsSep "\n" ([ ''&\text{${name}}\\'' ] ++ builtins.map makeLine diffs);
in
''
  $$
  \begin{flalign}
  ${section "CHANGED" changed}
  \text{}\\
  ${section "ADDED" added}
  \text{}\\
  ${section "REMOVED" removed}
  \text{}\\
  &\text{PATHS: ${toString data.paths.old} → ${toString data.paths.new} (+${toString data.paths.added}, –${toString data.paths.removed})}\\
  &\text{SIZE: ${format.bytes false data.size_old} → ${format.bytes false data.size_new}}\\
  &\text{DIFF: ${format.bytes true (data.size_new - data.size_old)}}
  \end{flalign}
  $$
''
