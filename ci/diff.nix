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
        content,
      }:
      let
        attrs = builtins.concatStringsSep "" [
          (if x != null then " x=\"${toString x}\"" else "")
          (if dy != null then " dy=\"${toString dy}\"" else "")
          (if class != null then " class=\"${class}\"" else "")
        ];
      in
      if attrs == "" then escape content else "<tspan${attrs}>${escape content}</tspan>";

    max = builtins.foldl' (
      max: line:
      let
        current = builtins.stringLength line;
      in
      if max > current then max else current
    ) 0;
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
    versions =
      items: x:
      if items == [ ] then
        ""
      else
        let
          first = builtins.head items;
          rest = builtins.tail items;

          tspan =
            first: item:
            helpers.tspan {
              x = if first then x else null;
              inherit (item) class content;
            };
        in
        builtins.concatStringsSep ", " ([ (tspan true first) ] ++ (map (tspan false) rest));

    line =
      diff:
      let
        transform =
          class: list:
          let
            items = map (content: { inherit content class; }) list;
          in
          if diff.has_omitted_versions then
            items
            ++ [
              {
                content = "unchanged";
                class = "gr";
              }
            ]
          else
            items;

        versions.raw = format.versions diff.versions;

        old = {
          list = builtins.filter (x: x != null) (map (v: v.old) versions.raw);
          items = transform "r" old.list;
        };

        new = {
          list = builtins.filter (x: x != null) (map (v: v.new) versions.raw);
          items = transform "g" new.list;
        };

        status = {
          inherit (config.status.${diff.status}) marker class;
        };
      in
      {
        text = {
          prefix = "${status.marker} ${diff.name}";

          details = builtins.concatStringsSep "" (
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
              if old.items != [ ] && new.items != [ ] then
                "${render.versions old.items dx} → ${render.versions new.items null}"
              else if old.items != [ ] then
                render.versions old.items dx
              else if new.items != [ ] then
                render.versions new.items dx
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

          body = builtins.concatStringsSep "" (map (line: "\n" + line.svg dimensions.prefix) lines);
        in
        {
          y = y + (builtins.length lines + 2) * config.font.height;

          svg = helpers.text {
            inherit y;
            content = title + body;
          };
        };
  };

  diffs = builtins.groupBy (
    diff:
    if diff.status == "Added" then
      "ADDED"
    else if diff.status == "Removed" then
      "REMOVED"
    else
      "CHANGED"
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
  <?xml version="1.0" encoding="UTF-8"?>
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
