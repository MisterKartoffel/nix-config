let
  data = builtins.fromJSON (builtins.readFile ./diff.json);

  config = {
    svg = {
      colors = {
        foreground = "#cdd6f4";
        background = "#1e1e2e";
        red = "#f38ba8";
        green = "#a6e3a1";
        blue = "#89b4fa";
        orange = "#fab387";
        yellow = "#f9e2af";
        gray = "#6c7086";
      };

      font = {
        family = "monospace";
        size = 16;
        height = 25;
        width = 10;
      };

      layout = {
        detailsX =
          config.svg.layout.padding
          +
            (
              helpers.max (
                builtins.concatLists (
                  map (
                    section:
                    map (
                      diff:
                      let
                        status = config.status.${diff.status};
                      in
                      "[${status.marker}] ${diff.name}"
                    ) section.diffs
                  ) sections
                )
              )
              + 1
            )
            * config.svg.font.width;

        width =
          config.svg.layout.detailsX
          +
            helpers.max (
              builtins.concatLists (map (section: map (diff: (makeLine diff).plain) section.diffs) sections)
            )
            * config.svg.font.width;

        padding = 16;
      };
    };

    status = {
      Added = {
        color = config.svg.colors.green;
        marker = "A.";
      };

      Removed = {
        color = config.svg.colors.red;
        marker = "R.";
      };

      Upgraded = {
        color = config.svg.colors.green;
        marker = "U.";
      };

      Downgraded = {
        color = config.svg.colors.red;
        marker = "D.";
      };

      Changed = {
        color = config.svg.colors.yellow;
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

  helpers = {
    escape =
      value:
      builtins.replaceStrings [ "&" "<" ">" "\"" "'" ] [ "&amp;" "&lt;" "&gt;" "&quot;" "&apos;" ] (
        toString value
      );

    text =
      {
        x,
        y,
        color ? config.svg.colors.foreground,
        font-family ? config.svg.font.family,
        font-size ? config.svg.font.size,
        content,
      }:
      ''
        <text
          x="${toString x}"
          y="${toString y}"
          fill="${color}"
          font-family="${font-family}"
          font-size="${toString font-size}"
        >${content}</text>
      '';

    tspan =
      {
        content,
        color ? null,
        font-weight ? null,
      }:
      "<tspan ${if color != null then ''fill="${color}"'' else ""} ${
        if font-weight != null then ''font-weight="${font-weight}"'' else ""
      }>${helpers.escape content}</tspan>";

    max =
      lines:
      builtins.foldl' (
        max: line:
        let
          length = builtins.stringLength (toString line);
        in
        if length > max then length else max
      ) 0 lines;
  };

  format = {
    bytes =
      signed: bytes:
      let
        abs = if bytes < 0 then -bytes else bytes;

        sign =
          if !signed || bytes == 0 then
            ""
          else if bytes > 0 then
            "+"
          else
            "–";

        unit = builtins.head (builtins.filter (u: abs + 1 >= u.size) config.units);

        scaled = (abs * 100 + unit.size / 2) / unit.size;
        integer = scaled / 100;
        fraction = scaled - integer * 100;

        decimal = if fraction < 10 then "0${toString fraction}" else toString fraction;
      in
      "${sign}${toString integer}.${decimal}${unit.suffix}";

    version =
      version:
      let
        amount = version.amount or 1;
      in
      version.name + (if amount == 1 then "" else " ×${toString amount}");

    versions = builtins.map (
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
          old = "${v.version.name} ×${toString v.old_amount}";
          new = "${v.version.name} ×${toString v.new_amount}";
        };
      }
      .${v.kind} or (throw "Unknown version kind: ${v.kind}")
    );
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
      oldText = map (
        value:
        helpers.tspan {
          content = value;
          color = config.svg.colors.red;
        }
      ) oldVersions;

      newText = map (
        value:
        helpers.tspan {
          content = value;
          color = config.svg.colors.green;
        }
      ) newVersions;

      render =
        text:
        builtins.concatStringsSep (helpers.tspan { content = ", "; }) (
          if omitted then
            text
            ++ [
              (helpers.tspan {
                content = "unchanged";
                color = config.svg.colors.gray;
              })
            ]
          else
            text
        );

      versions =
        if oldText == [ ] then
          render newText
        else if newText == [ ] then
          render oldText
        else
          (render oldText) + helpers.tspan { content = " → "; } + (render newText);

      size =
        if delta == 0 then
          ""
        else
          let
            separator = if versions != "" then helpers.tspan { content = ", "; } else "";

            color = if delta < 0 then config.svg.colors.blue else config.svg.colors.orange;
          in
          separator
          + helpers.tspan {
            content = format.bytes true delta;
            inherit color;
          };

      details = versions + size;
    in
    {
      plain = toString (
        builtins.filter (x: x != "") [
          (
            let
              unchanged = if omitted then "unchanged" else "";
              oldPlain = builtins.concatStringsSep ", " (oldVersions ++ [ unchanged ]);
              newPlain = builtins.concatStringsSep ", " (newVersions ++ [ unchanged ]);
            in
            if oldVersions == [ ] then
              newPlain
            else if newVersions == [ ] then
              oldPlain
            else
              "${oldPlain} → ${newPlain}"
          )
          (if delta != 0 then format.bytes true delta else "")
        ]
      );

      svg = {
        marker = helpers.tspan {
          content = "[${marker}]";
          inherit color;
        };
        name = helpers.tspan { content = "${name}"; };
        inherit details;
      };
    };

  makeLine =
    diff:
    let
      versions = format.versions diff.versions;

      oldVersions = builtins.filter (x: x != null) (map (v: v.old) versions);

      newVersions = builtins.filter (x: x != null) (map (v: v.new) versions);
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

  added = builtins.filter (diff: diff.status == "Added") data.diffs;
  removed = builtins.filter (diff: diff.status == "Removed") data.diffs;
  changed = builtins.filter (
    diff:
    builtins.elem diff.status [
      "Upgraded"
      "Downgraded"
      "Changed"
    ]
  ) data.diffs;

  sections = [
    {
      name = "CHANGED";
      diffs = changed;
    }
    {
      name = "ADDED";
      diffs = added;
    }
    {
      name = "REMOVED";
      diffs = removed;
    }
  ];

  footer = [
    "PATHS: ${toString data.paths.old} → ${toString data.paths.new} (+${toString data.paths.added}, –${toString data.paths.removed})"
    "SIZE: ${format.bytes false data.size_old} → ${format.bytes false data.size_new}"
    "DIFF: ${format.bytes true (data.size_new - data.size_old)}"
  ];

  renderDiff =
    diff:
    let
      line = makeLine diff;
    in
    {
      inherit (line.svg) marker name details;
    };

  renderSection =
    y:
    {
      name,
      diffs,
    }:
    if diffs == [ ] then
      {
        inherit y;
        svg = "";
      }
    else
      let
        rows = map renderDiff diffs;

        nameRows = builtins.genList (
          i:
          let
            row = builtins.elemAt rows i;
          in
          ''
            <tspan
              x="${toString config.svg.layout.padding}"
              dy="${toString config.svg.font.height}"
            >${row.marker} ${row.name}</tspan>
          ''
        ) (builtins.length rows);

        detailRows = builtins.genList (
          i:
          let
            row = builtins.elemAt rows i;
          in
          ''
            <tspan
              x="${toString config.svg.layout.detailsX}"
              dy="${toString (if i == 0 then 0 else config.svg.font.height)}"
            >${row.details}</tspan>
          ''
        ) (builtins.length rows);

      in
      {
        y = y + (builtins.length diffs + 2) * config.svg.font.height;

        svg =
          helpers.text {
            x = toString config.svg.layout.padding;
            y = toString y;
            content = ''
              <tspan
                font-weight="bold">
                ${helpers.escape name}
              </tspan>
              ${toString nameRows}
            '';
          }
          + helpers.text {
            x = toString config.svg.layout.padding;
            y = toString (y + config.svg.font.height);
            content = toString detailRows;
          };
      };

  rendered =
    let
      changed = renderSection 32 (builtins.elemAt sections 0);
      added = renderSection changed.y (builtins.elemAt sections 1);
      removed = renderSection added.y (builtins.elemAt sections 2);
      footerSvg = toString (
        builtins.genList (
          i:
          helpers.text {
            x = config.svg.layout.padding;
            y = removed.y + i * config.svg.font.height;
            content = builtins.elemAt footer i;
          }
        ) (builtins.length footer)
      );
    in
    {
      svg = builtins.concatStringsSep "\n" [
        changed.svg
        added.svg
        removed.svg
        footerSvg
      ];

      height = removed.y + builtins.length footer * config.svg.font.height + config.svg.layout.padding;
    };
in
''
  <?xml version="1.0" encoding="UTF-8"?>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="${toString config.svg.layout.width}"
    height="${toString rendered.height}"
    viewBox="0 0 ${toString config.svg.layout.width} ${toString rendered.height}"
  >
    <rect
      width="${toString config.svg.layout.width}"
      height="${toString rendered.height}"
      fill="${config.svg.colors.background}"
    />
    ${rendered.svg}
  </svg>
''
