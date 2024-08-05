{ config, ... }:

let
  colors = with config.colorScheme.colors; ''
    @define-color base00 alpha(#${base00}, 0.9);
    @define-color base01 alpha(#${base01}, 0.9);
    @define-color base02 alpha(#${base02}, 0.9);
    @define-color base03 alpha(#${base03}, 0.9);
    @define-color base04 alpha(#${base04}, 0.9);
    @define-color base05 alpha(#${base05}, 0.9);
    @define-color base06 alpha(#${base06}, 0.9);
    @define-color base07 alpha(#${base07}, 0.9);
    @define-color base08 alpha(#${base08}, 0.9);
    @define-color base09 alpha(#${base09}, 0.9);
    @define-color base0A alpha(#${base0A}, 0.9);
    @define-color base0B alpha(#${base0B}, 0.9);
    @define-color base0C alpha(#${base0C}, 0.9);
    @define-color base0D alpha(#${base0D}, 0.9);
    @define-color base0E alpha(#${base0E}, 0.9);
    @define-color base0F alpha(#${base0F}, 0.9);
  '';
in {
  programs.hjaltes-widgets = {
    enable = true;
    style = colors + builtins.readFile ./style.css;
  };
}
