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
        class = "g";
        marker = "[A.]";
      };

      Removed = {
        class = "r";
        marker = "[R.]";
      };

      Upgraded = {
        class = "g";
        marker = "[U.]";
      };

      Downgraded = {
        class = "r";
        marker = "[D.]";
      };

      Changed = {
        class = "y";
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
        content,
      }:
      ''<text y="${toString y}">${content}</text>'';

    tspan =
      {
        x ? null,
        dy ? null,
        class ? null,
        font-weight ? null,
        content,
      }:
      let
        attrs =
          (if x != null then " x=\"${toString x}\"" else "")
          + (if dy != null then " dy=\"${toString dy}\"" else "")
          + (if class != null then " class=\"${class}\"" else "")
          + (if font-weight != null then " font-weight=\"${font-weight}\"" else "");

        escaped = escape content;
      in
      if attrs == "" then escaped else "<tspan${attrs}>${escaped}</tspan>";

    max = builtins.foldl' (
      max: line:
      let
        current = builtins.stringLength line;
      in
      if max > current then max else current
    ) 0;
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
            "-";

        unit = builtins.head (builtins.filter (u: abs + 1 >= u.size) config.units);

        scaled = (abs * 100) / unit.size;
        integer = scaled / 100;
        decimal =
          let
            fraction = scaled - integer * 100;
          in
          if fraction < 10 then "0${toString fraction}" else toString fraction;
      in
      "${sign}${toString integer}.${decimal} ${unit.suffix}";

    versions =
      let
        string =
          {
            name,
            amount ? 1,
          }:
          name + (if amount == 1 then "" else " ×${toString amount}");

        kinds = {
          changed = v: {
            old = string v.old;
            new = string v.new;
          };

          added = v: {
            old = null;
            new = string v.version;
          };

          removed = v: {
            old = string v.version;
            new = null;
          };

          amount_changed = v: {
            old = "${v.version.name} ×${toString v.old_amount}";
            new = "${v.version.name} ×${toString v.new_amount}";
          };
        };
      in
      builtins.map (v: kinds.${v.kind} v);
  };

  render = {
    versions =
      items: omitted: class: x:
      if items == [ ] then
        ""
      else
        let
          first = helpers.tspan {
            inherit x class;
            content = builtins.head items;
          };

          rest = map (
            content:
            helpers.tspan {
              inherit class content;
            }
          ) (builtins.tail items);

          unchanged =
            if !omitted then
              [ ]
            else
              [
                (helpers.tspan {
                  content = "unchanged";
                  class = "gr";
                })
              ];
        in
        builtins.concatStringsSep ", " ([ first ] ++ rest ++ unchanged);

    line =
      diff:
      let
        generate = field: class: rec {
          list = builtins.filter (x: x != null) (builtins.catAttrs field versions.raw);
          rendered = dx: render.versions list omitted class dx;
        };

        versions.raw = format.versions diff.versions;

        old = generate "old" "r";
        new = generate "new" "g";

        omitted = diff.has_omitted_versions;
        status = config.status.${diff.status};
      in
      {
        text = {
          prefix = "${status.marker} ${diff.name}";

          details =
            let
              versions =
                let
                  unchanged = if omitted then [ "unchanged" ] else [ ];
                  oldPlain = builtins.concatStringsSep ", " (old.list ++ unchanged);
                  newPlain = builtins.concatStringsSep ", " (new.list ++ unchanged);
                in
                if old.list == [ ] then
                  newPlain
                else if new.list == [ ] then
                  oldPlain
                else
                  "${oldPlain} → ${newPlain}";

              size = if diff.size_delta == 0 then "" else format.bytes true diff.size_delta;
            in
            versions + size;
        };

        svg =
          dx:
          let
            marker = helpers.tspan {
              x = config.padding;
              dy = config.font.height;
              inherit (status) class;
              content = status.marker;
            };

            versions =
              if old.list != [ ] && new.list != [ ] then
                "${old.rendered dx} → ${new.rendered null}"
              else if old.list != [ ] then
                old.rendered dx
              else if new.list != [ ] then
                new.rendered dx
              else
                "";

            size =
              if diff.size_delta == 0 then
                ""
              else
                let
                  separator = if versions == "" then "" else ", ";
                  class = if diff.size_delta < 0 then "b" else "o";
                  x = if versions == "" then dx else null;
                in
                separator
                + helpers.tspan {
                  inherit x class;
                  content = format.bytes true diff.size_delta;
                };
          in
          "${marker} ${helpers.escape diff.name}${versions}${size}";
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
          title = ''<tspan x="${toString config.padding}" font-weight="bold">${helpers.escape category}</tspan>'';
          body = map (line: line.svg dimensions.prefix) lines;
        in
        {
          y = y + (builtins.length lines + 2) * config.font.height;

          svg = helpers.text {
            inherit y;
            content = builtins.concatStringsSep "\n" ([ title ] ++ body);
          };
        };
  };

  diffs = builtins.groupBy (
    diff:
    {
      Added = "ADDED";
      Removed = "REMOVED";
    }
    .${diff.status} or "CHANGED"
  ) data.diffs;

  sections = {
    raw = [
      {
        category = "CHANGED";
        diffs = diffs.CHANGED or [ ];
      }
      {
        category = "ADDED";
        diffs = diffs.ADDED or [ ];
      }
      {
        category = "REMOVED";
        diffs = diffs.REMOVED or [ ];
      }
    ];

    list = map (section: {
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
            svg = acc.svg + "\n" + res.svg;
          }
        )
        {
          y = config.font.height;
          svg = "";
        }
        sections.list;

    footer = {
      list = [
        "PATHS: ${toString data.paths.old} → ${toString data.paths.new} (+${toString data.paths.added}, –${toString data.paths.removed})"
        "SIZE: ${format.bytes false data.size_old} → ${format.bytes false data.size_new}"
        "DIFF: ${format.bytes true (data.size_new - data.size_old)}"
      ];

      svg = helpers.text {
        y = sections.rendered.y;
        content = builtins.concatStringsSep "" (
          map (line: ''
            <tspan x="${toString config.padding}" dy="${toString config.font.height}">${helpers.escape line}</tspan>
          '') sections.footer.list
        );
      };
    };
  };

  dimensions =
    let
      text = builtins.catAttrs "text" (builtins.concatMap (s: s.lines) sections.list);
    in
    rec {
      prefix = config.padding + (helpers.max (builtins.catAttrs "prefix" text) + 1) * config.font.width;
      details = (helpers.max (builtins.catAttrs "details" text) - 2) * config.font.width;
      width = prefix + details;
      height = sections.rendered.y + (builtins.length sections.footer.list + 1) * config.font.height;
    };
in
''
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="${toString dimensions.width}"
    height="${toString dimensions.height}"
    viewBox="0 0 ${toString dimensions.width} ${toString dimensions.height}"
    fill="${config.colors.foreground}"
    font-family="${config.font.family}"
    font-size="${toString config.font.size}"
  >
  <style>
    .g { fill: ${config.colors.green}; }
    .r { fill: ${config.colors.red}; }
    .y { fill: ${config.colors.yellow}; }
    .b { fill: ${config.colors.blue}; }
    .o { fill: ${config.colors.orange}; }
    .gr { fill: ${config.colors.gray}; }
  </style>
  <rect
    width="${toString dimensions.width}"
    height="${toString dimensions.height}"
    fill="${config.colors.background}"
  />${sections.rendered.svg}
  ${sections.footer.svg}
  </svg>
''
