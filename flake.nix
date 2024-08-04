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

    hjaltes-widgets = {
      url = "github:ChangeCaps/hjaltes-widgets";
      inputs.nixpkgs.follows = "nixpkgs";
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
          "electron-27.3.11"
          "electron-28.3.3"
        ];
      };
    };
  in {
    setup = { home, system, username, hostname }: {
      homeConfigurations = {
        anon = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ 
            # Include the default Home Manager modules.
            inputs.nix-colors.homeManagerModules.default
            inputs.hjaltes-widgets.homeManagerModules.default

            ./home
            home
          ];

          extraSpecialArgs = {
            inherit inputs;
            inherit username;
          };
        };
      };

      nixosConfigurations = {
        anon = nixpkgs.lib.nixosSystem {
          modules = [ 
            ./system
            system
          ];

          specialArgs = { 
            inherit inputs; 
            inherit username;
            inherit hostname;
          };
        };
      };
    };  
  };
}
