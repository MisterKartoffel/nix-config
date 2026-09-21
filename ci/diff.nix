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
        x,
        y,
        color ? config.colors.foreground,
        font-family ? config.font.family,
        font-size ? config.font.size,
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
      }:
      "<tspan ${if color != null then ''fill="${color}"'' else ""}>${escape content}</tspan>";

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

  diffLine =
    diff:
    let
      render =
        text:
        builtins.concatStringsSep (helpers.tspan { content = ", "; }) (
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
        rendered = render old.text;
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
        rendered = render new.text;
      };

      versions = {
        raw = format.versions diff.versions;
        rendered =
          if old.text == [ ] then
            new.rendered
          else if new.text == [ ] then
            old.rendered
          else
            old.rendered + helpers.tspan { content = " → "; } + new.rendered;
      };

      size =
        if diff.size_delta == 0 then
          ""
        else
          let
            separator = if versions.rendered == "" then "" else helpers.tspan { content = ", "; };
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
            (if diff.size_delta != 0 then format.bytes true diff.size_delta else "")
          ]
        );
      };

      svg = {
        marker = helpers.tspan {
          content = marker;
          inherit color;
        };
        name = helpers.tspan { content = diff.name; };
        details = versions.rendered + size;
      };
    };

  sections = {
    raw = [
      {
        name = "CHANGED";
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
        name = "ADDED";
        diffs = builtins.filter (diff: diff.status == "Added") data.diffs;
      }
      {
        name = "REMOVED";
        diffs = builtins.filter (diff: diff.status == "Removed") data.diffs;
      }
    ];

    processed = map (section: {
      inherit (section) name;
      lines = map diffLine section.diffs;
    }) sections.raw;

    rendered =
      builtins.foldl'
        (
          acc: section:
          let
            res = renderSection acc.y section;
          in
          {
            inherit (res) y;
            svg = if res.svg == "" then acc.svg else acc.svg + "\n" + res.svg;
          }
        )
        {
          y = 32;
          svg = "";
        }
        sections.processed;
  };

  sizes = rec {
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
      (helpers.max (
        builtins.concatLists (
          map (section: map (line: line.plain.details) section.lines) sections.processed
        )
      ))
      * config.font.width;

    width = prefix + details;

    height = sections.rendered.y + (builtins.length footer) * config.font.height;
  };

  footer = [
    "PATHS: ${toString data.paths.old} → ${toString data.paths.new} (+${toString data.paths.added}, –${toString data.paths.removed})"
    "SIZE: ${format.bytes false data.size_old} → ${format.bytes false data.size_new}"
    "DIFF: ${format.bytes true (data.size_new - data.size_old)}"
  ];

  renderSection =
    y:
    {
      name,
      lines,
    }:
    if lines == [ ] then
      {
        inherit y;
        svg = "";
      }
    else
      let
        nameRowsSvg = toString (
          map (line: ''
            <tspan
              x="${toString config.padding}"
              dy="${toString config.font.height}"
            >${line.svg.marker} ${line.svg.name}</tspan>
          '') lines
        );

        detailRowsSvg = toString (
          map (line: ''
            <tspan
              x="${toString sizes.prefix}"
              dy="${toString config.font.height}"
            >${line.svg.details}</tspan>
          '') lines
        );
      in
      {
        y = y + (builtins.length lines + 2) * config.font.height;

        svg =
          helpers.text {
            x = config.padding;
            inherit y;
            content = ''
              <tspan
                font-weight="bold">
                ${helpers.escape name}
              </tspan>
              ${nameRowsSvg}
            '';
          }
          + helpers.text {
            x = config.padding;
            inherit y;
            content = detailRowsSvg;
          };
      };

  footerSvg = builtins.concatStringsSep "\n" (
    builtins.genList (
      i:
      helpers.text {
        x = config.padding;
        y = sections.rendered.y + i * config.font.height;
        content = builtins.elemAt footer i;
      }
    ) (builtins.length footer)
  );
in
''
  <?xml version="1.0" encoding="UTF-8"?>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="${toString sizes.width}"
    height="${toString sizes.height}"
    viewBox="0 0 ${toString sizes.width} ${toString sizes.height}"
  >
    <rect
      width="${toString sizes.width}"
      height="${toString sizes.height}"
      fill="${config.colors.background}"
    />
    ${sections.rendered.svg}
    ${footerSvg}
  </svg>
''
