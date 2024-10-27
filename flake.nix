{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    packages.${system} = {
      default = pkgs.callPackage ./plastic.nix {};
      tui = pkgs.callPackage ./plastic-tui.nix {};
    };
  };
}
