let
  data = builtins.fromJSON (builtins.readFile ./diff.json);

  config = rec {
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
      width = 10;
      height = 25;
    };

    padding = font.size;

    status = {
      Added = {
        color = colors.green;
        marker = "[A.]";
      };

      Removed = {
        color = colors.red;
        marker = "[R.]";
      };

      Upgraded = {
        color = colors.green;
        marker = "[U.]";
      };

      Downgraded = {
        color = colors.red;
        marker = "[D.]";
      };

      Changed = {
        color = colors.yellow;
        marker = "[C.]";
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

  helpers = rec {
    escape =
      value:
      builtins.replaceStrings [ "&" "<" ">" "\"" "'" ] [ "&amp;" "&lt;" "&gt;" "&quot;" "&apos;" ] (
        toString value
      );

    text =
      {
        y,
        color ? config.colors.foreground,
        font-family ? config.font.family,
        font-size ? config.font.size,
        content,
      }:
      ''
        <text
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
      }:
      "<tspan ${if color == null then "" else ''fill="${color}"''}>${escape content}</tspan>";

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

  format = rec {
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
      v:
      let
        amount = v.amount or 1;
      in
      v.name + (if amount == 1 then "" else " ×${toString amount}");

    versions = builtins.map (
      v:
      {
        changed = {
          old = version v.old;
          new = version v.new;
        };

        added = {
          old = null;
          new = version v.version;
        };

        removed = {
          old = version v.version;
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

  render = {
    line =
      diff:
      let
        realize =
          text:
          builtins.concatStringsSep ", " (
            if diff.has_omitted_versions then
              text
              ++ [
                (helpers.tspan {
                  content = "unchanged";
                  color = config.colors.gray;
                })
              ]
            else
              text
          );

        old = {
          list = builtins.filter (x: x != null) (map (v: v.old) versions.raw);
          text = map (
            content:
            helpers.tspan {
              inherit content;
              color = config.colors.red;
            }
          ) old.list;
          rendered = realize old.text;
        };

        new = {
          list = builtins.filter (x: x != null) (map (v: v.new) versions.raw);
          text = map (
            content:
            helpers.tspan {
              inherit content;
              color = config.colors.green;
            }
          ) new.list;
          rendered = realize new.text;
        };

        versions = {
          raw = format.versions diff.versions;
          rendered =
            if old.text == [ ] then
              new.rendered
            else if new.text == [ ] then
              old.rendered
            else
              old.rendered + " → " + new.rendered;
        };

        size =
          if diff.size_delta == 0 then
            ""
          else
            let
              separator = if versions.rendered == "" then "" else ", ";
              color = if diff.size_delta < 0 then config.colors.blue else config.colors.orange;
            in
            separator
            + helpers.tspan {
              content = format.bytes true diff.size_delta;
              inherit color;
            };

        inherit (config.status.${diff.status}) marker color;
      in
      {
        plain = {
          prefix = "${marker} ${diff.name}";

          details = toString (
            builtins.filter (x: x != "") [
              (
                let
                  unchanged = if diff.has_omitted_versions then [ "unchanged" ] else [ ];
                  oldPlain = builtins.concatStringsSep ", " (old.list ++ unchanged);
                  newPlain = builtins.concatStringsSep ", " (new.list ++ unchanged);
                in
                if old.list == [ ] then
                  newPlain
                else if new.list == [ ] then
                  oldPlain
                else
                  "${oldPlain} → ${newPlain}"
              )
              (if diff.size_delta == 0 then "" else format.bytes true diff.size_delta)
            ]
          );
        };

        svg = {
          marker = helpers.tspan {
            content = marker;
            inherit color;
          };
          inherit (diff) name;
          details = versions.rendered + size;
        };
      };

    section =
      y:
      {
        category,
        lines,
      }:
      if lines == [ ] then
        {
          inherit y;
          svg = "";
        }
      else
        let
          title = ''
            <tspan
              x="${toString config.padding}"
              font-weight="bold"
            >${helpers.escape category}</tspan>
          '';

          text = toString (
            map (line: ''
              <tspan
                x="${toString config.padding}"
                dy="${toString config.font.height}"
              >${line.svg.marker} ${line.svg.name}</tspan>
              <tspan
                x="${toString dimensions.prefix}"
              >${line.svg.details}</tspan>
            '') lines
          );
        in
        {
          y = y + (builtins.length lines + 2) * config.font.height;

          svg = helpers.text {
            inherit y;
            content = title + text;
          };
        };
  };

  sections = {
    raw = [
      {
        category = "CHANGED";
        diffs = builtins.filter (
          diff:
          builtins.elem diff.status [
            "Upgraded"
            "Downgraded"
            "Changed"
          ]
        ) data.diffs;
      }
      {
        category = "ADDED";
        diffs = builtins.filter (diff: diff.status == "Added") data.diffs;
      }
      {
        category = "REMOVED";
        diffs = builtins.filter (diff: diff.status == "Removed") data.diffs;
      }
    ];

    processed = map (section: {
      inherit (section) category;
      lines = map render.line section.diffs;
    }) sections.raw;

    rendered =
      builtins.foldl'
        (
          acc: section:
          let
            res = render.section acc.y section;
          in
          {
            inherit (res) y;
            svg = acc.svg + res.svg;
          }
        )
        {
          y = config.font.height;
          svg = "";
        }
        sections.processed;

    footer = {
      raw = [
        "PATHS: ${toString data.paths.old} → ${toString data.paths.new} (+${toString data.paths.added}, –${toString data.paths.removed})"
        "SIZE: ${format.bytes false data.size_old} → ${format.bytes false data.size_new}"
        "DIFF: ${format.bytes true (data.size_new - data.size_old)}"
      ];

      svg = helpers.text {
        y = sections.rendered.y;
        content = toString (
          map (line: ''
            <tspan
              x="${toString config.padding}"
              dy="${toString config.font.height}"
            >${line}</tspan>
          '') sections.footer.raw
        );
      };
    };
  };

  dimensions = rec {
    prefix =
      config.padding
      +
        (
          helpers.max (
            builtins.concatLists (map (section: map (line: line.plain.prefix) section.lines) sections.processed)
          )
          + 1
        )
        * config.font.width;

    details =
      helpers.max (
        builtins.concatLists (
          map (section: map (line: line.plain.details) section.lines) sections.processed
        )
      )
      * config.font.width;

    width = prefix + details;
    height = sections.rendered.y + (builtins.length sections.footer.raw + 1) * config.font.height;
  };

in
''
  <?xml version="1.0" encoding="UTF-8"?>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="${toString dimensions.width}"
    height="${toString dimensions.height}"
    viewBox="0 0 ${toString dimensions.width} ${toString dimensions.height}"
  >
    <rect
      width="${toString dimensions.width}"
      height="${toString dimensions.height}"
      fill="${config.colors.background}"
    />
    ${sections.rendered.svg}
    ${sections.footer.svg}
  </svg>
''
