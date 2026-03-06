{ config, pkgs, lib, ... }: 

{
  options.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git";
    };
    
    name = lib.mkOption {
      type = lib.types.str;
      example = "John Doe";
      description = "The name to use for git commits";
    };

    email = lib.mkOption {
      type = lib.types.str;
      example = "john@doe.org";
      description = "The email to use for git commits";
    };
  };

  config = {
    programs.git = {
      enable = config.git.enable;
      package = pkgs.gitFull;
      settings = {
        user = {
          name = config.git.name;
          email = config.git.email;
        };

        credential.helper = "libsecret";
        init.defaultBranch = "main";
        pull.rebase = false;
        submodule.recurse = true;
      };
    }; 
  };
}
