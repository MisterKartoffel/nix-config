(import (
  let
    defaults = {
      url = "https://github.com/NixOS/flake-compat/archive/${pin.rev}.tar.gz";
      rev = "5edf11c44bc78a0d334f6334cdaf7d60d732daab";
      narHash = "sha256-vNpUSpF5Nuw8xvDLj2KCwwksIbjua2LZCqhV1LNRDns=";
    };

    lock = builtins.fromJSON (builtins.readFile ./.tack/pins.lock.json);
    pin = lock.flake-compat or defaults;
  in
  fetchTarball {
    inherit (pin) url;
    sha256 = pin.narHash;
  }
) { src = ./.; }).outputs
