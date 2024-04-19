{ inputs, config, pkgs, ... }:

{
  gtk = {
    enable = true;

    iconTheme = {
      name = "Yaru-magenta-dark";
      package = pkgs.yaru-theme;
    };

    theme = {
      name = "Catppuccin-Macchiato-Standard-Teal-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "teal" ];
        size = "standard";
        variant = "macchiato";
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
    platformTheme = "gnome";
  };
}
