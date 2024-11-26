{ pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita Dark";
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
