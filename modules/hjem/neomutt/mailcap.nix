{ pkgs, lib, ... }:
{
  xdg.config.files."neomutt/mailcap".text = /* bash */ ''
    text/html; ${lib.getExe pkgs.w3m} -I %{charset} -T text/html -cols ''${COLUMNS} -dump; copiousoutput
  '';
}
