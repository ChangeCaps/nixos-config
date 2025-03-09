{
  description = "System config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
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

    lute = {
      url = "github:ChangeCaps/lute";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjaltes-widgets = {
      url = "github:ChangeCaps/hjaltes-widgets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
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
        "${hostname}" = home-manager.lib.homeManagerConfiguration {
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
        "${hostname}" = nixpkgs.lib.nixosSystem {
          modules = [ 
            inputs.musnix.nixosModules.musnix

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
