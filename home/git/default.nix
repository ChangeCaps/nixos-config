{ inputs, config, pkgs, lib, ... }: 

{
  options.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git";
    };
    
    userName = lib.mkOption {
      type = lib.types.str;
      example = "John Doe";
      description = "The name to use for git commits";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      example = "john@doe.org";
      description = "The email to use for git commits";
    };
  };

  config = {
    programs.git = {
      enable = config.git.enable;
      package = pkgs.gitFull;
      userName = config.git.userName;
      userEmail = config.git.userEmail;
      extraConfig = {
        credential.helper = "libsecret";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    }; 
  };
}
