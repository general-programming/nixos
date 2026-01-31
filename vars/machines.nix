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
  sea1-core = {
    machineID = "0f72ad909d2ad7732a0b7865697e89cf";
  };
  fmt2-core = {
    machineID = "8b216aac9ac44002aacf262aacca1081";
  };
}
