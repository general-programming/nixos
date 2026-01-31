{ nixpkgs, ... }:

let
  base = {
    ports = {
      comin-exporter = 41001;
    };
  };
in

nixpkgs.lib.mapAttrs (_: nixpkgs.lib.attrsets.recursiveUpdate base) {
  _ = { };
  sea1-core = { };
}
