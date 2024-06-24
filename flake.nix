{
  description = "System config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
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
        
        permittedInsecurePackages = [
          "electron-28.3.3"
        ];
      };
    };
  in {
    homeConfigurations = {
      anon = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ 
          # Include the default Home Manager modules.
          inputs.nix-colors.homeManagerModules.default

          ./home
          ./home.nix 
        ];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };

    nixosConfigurations = {
      anon = nixpkgs.lib.nixosSystem {
        modules = [ 
          ./system
          ./configuration.nix 
        ];

        specialArgs = { 
          inherit inputs; 
        };
      };
    };
  };
}
