{ pkgs, ... }:

{
  gtk = {
    enable = true;

    iconTheme = {
      name = "Yaru-magenta-dark";
      package = pkgs.yaru-theme;
    };

    theme = {
      name = "catppuccin-mocha-teal-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "teal" ];
        size = "standard";
        variant = "mocha";
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  }; 

  qt = {
    enable = true;

    style.name = "adwaita-dark";
    platformTheme.name = "adwaita";
  };
}
