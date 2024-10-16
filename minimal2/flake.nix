{
    description = "nixos config";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }@inputs:
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
        in
        {
            nixosConfigurations.default = nixpkgs.lib.nixosSystem {
                extraSpecialArgs = {inherit inputs;};
                modules = [
                    .configuration.nix
                ];
            };
        };
}