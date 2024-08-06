{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.lute.packages.${pkgs.stdenv.hostPlatform.system}.lute
  ];
}
