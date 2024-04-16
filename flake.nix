{
  description = "System config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-config = {
      url = "github:ChangeCaps/neovim-config";
      flake = false;
    }; 
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: 
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs { 
      inherit system;

      config = {
        allowUnfree = true;
      };
    };
  in {
    homeConfigurations = {
      anon = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home/home.nix ];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };

    nixosConfigurations = {
      anon = nixpkgs.lib.nixosSystem rec {
        modules = [ ./nixos/configuration.nix ];

        specialArgs = { 
          inherit inputs; 
        };
      };
    };
  };
}
