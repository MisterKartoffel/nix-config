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
      list: omitted:
      let
        kinds =
          let
            string =
              {
                name,
                amount ? 1,
              }:
              name + (if amount == 1 then "" else " ×${toString amount}");
          in
          {
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
              old = string {
                inherit (v.version) name;
                amount = v.old_amount;
              };

              new = string {
                inherit (v.version) name;
                amount = v.new_amount;
              };
            };
          };

        mapped = map (v: kinds.${v.kind} v) list;
        unchanged = if !omitted then [ ] else [ "unchanged" ];
      in
      builtins.mapAttrs
        (name: class: rec {
          list = builtins.filter (x: x != null) (builtins.catAttrs name mapped);
          plain = builtins.concatStringsSep ", " (list ++ unchanged);
          rendered = dx: render.versions list omitted class dx;
        })
        {
          old = "r";
          new = "g";
        };
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
        inherit (format.versions diff.versions diff.has_omitted_versions) old new;
        status = config.status.${diff.status};
      in
      {
        plain = {
          prefix = "${status.marker} ${diff.name} ";

          details =
            let
              versions =
                if old.list == [ ] then
                  new.plain
                else if new.list == [ ] then
                  old.plain
                else
                  "${old.plain} → ${new.plain}";

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
              if old.list == [ ] then
                new.rendered dx
              else if new.list == [ ] then
                old.rendered dx
              else
                "${old.rendered dx} → ${new.rendered null}";

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
      let
        title = helpers.tspan {
          x = config.padding;
          dy = 2 * config.font.height;
          font-weight = "bold";
          content = category;
        };
        body = map (line: line.svg dimensions.prefix) lines;
      in
      {
        y = y + (builtins.length lines + 2) * config.font.height;
        svg = builtins.concatStringsSep "\n" ([ title ] ++ body);
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
    list = builtins.filter (s: s.lines != [ ]) (
      map
        (category: {
          inherit category;
          lines = map render.line (diffs.${category} or [ ]);
        })
        [
          "CHANGED"
          "ADDED"
          "REMOVED"
        ]
    );

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
      list =
        let
          compare = old: new: {
            old = if old > new then "r" else "g";
            new = if old > new then "g" else "r";
          };

          paths = compare data.paths.old data.paths.new;
          size = compare data.size_old data.size_new;

          category =
            content:
            helpers.tspan {
              x = config.padding;
              dy = 2 * config.font.height;
              font-weight = "bold";
              inherit content;
            };

          row =
            content:
            helpers.tspan {
              x = config.padding;
              dy = config.font.height;
              inherit content;
            };

          span =
            class: content:
            helpers.tspan {
              inherit class content;
            };
        in
        [
          (category "SUMMARY")
          "${row "PATHS: "}${span paths.old data.paths.old} → ${span paths.new data.paths.new} (${span "r" "+${toString data.paths.added}"}, ${span "g" "-${toString data.paths.removed}"})"
          "${row "SIZE: "}${span size.old (format.bytes false data.size_old)} → ${span size.new (format.bytes false data.size_new)}"
          "${row "DIFF: "}${span size.new (format.bytes true (data.size_new - data.size_old))}"
        ];

      svg = builtins.concatStringsSep "\n" sections.footer.list;
    };
  };

  dimensions =
    let
      plain = builtins.catAttrs "plain" (builtins.concatMap (s: s.lines) sections.list);
    in
    rec {
      prefix = helpers.max (builtins.catAttrs "prefix" plain) * config.font.width + config.padding;
      details = helpers.max (builtins.catAttrs "details" plain) * config.font.width;
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
  /><text>${sections.rendered.svg}
  ${sections.footer.svg}
  </text>
  </svg>
''
