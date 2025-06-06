{ pkgs, ... }: {
  home.packages = [ pkgs.gdb ];

  home.file.gdbinit = {
    source = pkgs.fetchFromGitHub {
      owner = "cyrus-and";
      repo = "gdb-dashboard";
      rev = "616ed5100d3588bb70e3b86737ac0609ce0635cc";
      hash = "sha256-xoBkAFwkbaAsvgPwGwe1JxE1C8gPR6GP1iXeNKK5Z70=";
    } + /.gdbinit;
    target = ".gdbinit";
  };

  home.file.gdb_dashboard_init = {
    text = ''
      # gdb-dashboard init file

      # available layout modules
      #   stack registers history assembly
      #   breakpoints expressions memory
      #   source threads variables
      dashboard -layout source
    '';
    target = ".gdbinit.d/init";
  };
}
