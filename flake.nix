{
  # This works just fine (last-known-good 29c07054efdbbb8719e8e5487c86878215b7205a)
  #inputs.nixpkgs.url = github:nixos/nixpkgs/nixpkgs-22.11-darwin;
  inputs.nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
  outputs = {nixpkgs, ...}: let
    overlay = final: prev:
      if prev.targetPlatform.isLinux
      then {
        repro = builtins.trace "this causes an infinite recursion on `nixpkgs-unstable`" prev.hello;
      }
      else {};
  in {
    packages.x86_64-linux.repro = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [overlay];
      };
    in
      pkgs.repro;
  };
}
