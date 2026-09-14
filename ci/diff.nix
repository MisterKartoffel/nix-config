let
  statuses = {
    Upgraded = {
      marker = "[U.]";
      color = "green";
      section = "CHANGED";
    };

    Downgraded = {
      marker = "[D.]";
      color = "red";
      section = "CHANGED";
    };

    Changed = {
      marker = "[C.]";
      color = "yellow";
      section = "CHANGED";
    };

    Added = {
      marker = "[A.]";
      color = "green";
      section = "ADDED";
    };

    Removed = {
      marker = "[R.]";
      color = "red";
      section = "REMOVED";
    };
  };

  arrow = " → ";
  text = s: "\\text{${s}}";
  special = s: "\\<${s}\\>";
  color = c: s: "{\\color{${c}}${s}}";

  round3 =
    n:
    let
      factor =
        if n < 10 then
          100
        else if n < 100 then
          10
        else
          1;
    in
    builtins.floor (n * factor + 0.5) / factor;

  size =
    bytes:
    let
      abs = if bytes > 0 then bytes else -bytes;

      sign =
        if bytes > 0 then
          "+"
        else if bytes < 0 then
          "-"
        else
          "";

      units = [
        {
          suffix = "GiB";
          threshold = 1024 * 1024 * 1024;
        }
        {
          suffix = "MiB";
          threshold = 1024 * 1024;
        }
        {
          suffix = "KiB";
          threshold = 1024;
        }
        {
          suffix = "B";
          threshold = 1;
        }
      ];

      unit = builtins.head (builtins.filter (u: abs >= u.threshold) units);

      value = if unit.threshold == 1 then abs else round3 (abs / unit.threshold);
    in
    "${sign}${toString value} ${unit.suffix}";

  plainVersion =
    v:
    let
      inherit (v) name;
      amount = if (v.amount or 1) == 1 then "" else "×${toString v.amount}";
    in
    name + amount;

  version = c: v: color c (plainVersion v);

  versionDiff =
    diff:
    let
      pair = old: new: version "red" old + arrow + version "green" new;
    in
    {
      changed = pair diff.old diff.new;
      added = version "green" diff.version;
      removed = version "red" diff.version;

      amount_changed =
        pair
          {
            inherit (diff.version) name;
            amount = diff.old_amount;
          }
          {
            inherit (diff.version) name;
            amount = diff.new_amount;
          };
    }
    .${diff.kind} or (throw "Unknown version diff kind: ${diff.kind}");

  packageVersion =
    diff:
    let
      changed = builtins.filter (v: v.kind == "changed") diff.versions;
      other = builtins.filter (v: v.kind != "changed") diff.versions;

      old = builtins.concatStringsSep ", " (map (v: version "red" v.old) changed);
      new = builtins.concatStringsSep ", " (map (v: version "green" v.new) changed);

      unchanged = color "gray" (special "unchanged");
    in
    if diff.versions == [ ] then
      ""
    else if diff.has_omitted_versions then
      "${old}, ${unchanged + arrow + new}, ${unchanged}"
    else
      builtins.concatStringsSep ", " (
        builtins.filter (s: s != "") [
          (if changed == [ ] then "" else old + arrow + new)
          (builtins.concatStringsSep ", " (map versionDiff other))
        ]
      );

  package =
    diff:
    let
      left =
        let
          status = statuses.${diff.status};
        in
        "${color status.color status.marker} ${diff.name}";

      right = builtins.concatStringsSep ", " (
        builtins.filter (s: s != "") [
          (packageVersion diff)
          (
            if diff.size_delta == 0 then
              ""
            else
              color (if diff.size_delta < 0 then "blue" else "orange") (size diff.size_delta)
          )
        ]
      );

    in
    "&${text left}&&${text right}";

  renderSection =
    name: diffs:
    let
      matching = builtins.filter (d: (statuses.${d.status} or { }).section or null == name) diffs;
      rows = [ "&${text name}" ] ++ map package matching;
    in
    if matching == [ ] then "" else builtins.concatStringsSep "\\\\\n" rows;

  pathSummary =
    paths:
    text "PATHS: ${paths.old} ${arrow} ${paths.new} (${color "green" "+${toString paths.added}"}, ${color "red" "-${toString paths.removed}"})";

  sizeSummary = diff: text "SIZE: ${size diff.size_old} ${arrow} ${size diff.size_new}";

  diffSummary =
    diff:
    let
      delta = diff.size_new - diff.size_old;
      formatted = size delta;
    in
    text "DIFF: ${color (if delta <= 0 then "green" else "red") formatted}";
in
{
  parse =
    file:
    let
      data = builtins.fromJSON (builtins.readFile file);

      sections = builtins.filter (s: s != "") (
        map (name: renderSection name data.diffs) [
          "CHANGED"
          "ADDED"
          "REMOVED"
        ]
      );
    in
    ''
      $$
      \begin{flalign}
      ${builtins.concatStringsSep "\\\\\n${text ""}\\\\\n" sections}
      \end{flalign}
      $$

      ${pathSummary data.paths}
      ${sizeSummary data}
      ${diffSummary data}

    '';
}
