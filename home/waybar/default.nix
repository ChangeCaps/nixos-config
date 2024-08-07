{ config, pkgs, ... }: 
let 
  hyprland = config.wayland.windowManager.hyprland.package;
  execFloating = cmd: "${hyprland}/bin/hyprctl dispatch exec [floating] ${cmd}";
  widgets = "${config.programs.hjaltes-widgets.package}/bin/hjaltes-widgets";

  colors = with config.colorScheme.palette; ''
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
  home.packages = [ 
    pkgs.playerctl
    pkgs.fira
  ];

  programs.waybar = {
    enable = true;

    style = colors + builtins.readFile ./style.css;

    settings = {
      mainBar = {
        margin = "8 8 0 8";

	      modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "custom/separator"
          "custom/media"
        ];

	      modules-center = [  
          "hyprland/window" 
        ];

	      modules-right = [
          "privacy"
          "backlight" 
          "pulseaudio" 
          "custom/separator"
          "network"
          "battery" 
          "custom/separator"
          "clock" 
          "custom/separator"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          format = "";
          all-outputs = true;
          move-to-monitor = true;
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 50;
        };
	
	      pulseaudio = {
          scroll-step =  5;
          format = "{icon} ";
          format-muted = " ";

          on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = execFloating "${pkgs.pavucontrol}/bin/pavucontrol";
          format-icons = {
            default = [ "" "" "" ];
          };
        };

        network = {
          tooltip = true;
          tooltip-format-wifi = "wifi: {essid} {signalStrength}%";
          tooltip-format-ethernet = "eth: {ifname}";
          tooltip-format-disconnected = "disconnected";

          format-wifi = "network_wifi";
          format-ethernet = "lan";
          format-linked = "public_off";
          format-disconnected = "signal_disconnected";

          on-click = execFloating "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };

        backlight = {
          tooltip = false;
          format =  "  {}%";
          interval = 1;
          on-scroll-up = "${pkgs.light}/bin/light -A 5";
          on-scroll-down = "${pkgs.light}/bin/light -U 5";
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };

          format = "{icon} ";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt =  "{time}   {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        clock = {
          format = "{:%H:%M %p %d/%m/%Y}";
        };

        cpu = {
          interval = 15;
          format = "  {}%";
          max-length = 10;
        };

        memory = {
          interval = 30;
          format = "  {}%";
          max-length = 10;
        };

        privacy = {
          icon-spacing = 12;
          icon-size = 14;
        };

        "custom/separator" = {
          format = "|";
        };

        "custom/media" = {
          restart-interval = 30;
          format = "{icon}   {}";
          return-type = "json";
          max-length = 20;

          format-icons = {
            Playing = " ";
            Paused = " ";
          };

          exec = "${pkgs.fish}/bin/fish ${./fetch_music_player_data.fish}";
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
        };

        "custom/launcher" = {
          format = " ";
          on-click = "${pkgs.wofi}/bin/wofi --show drun";
          on-click-right = "${pkgs.killall}/bin/killall .wofi-wrapped";
        };

        "custom/power" = {
          format = " ";
          on-click = "${widgets} config-menu";
        };

        "custom/wallpaper" = {
          format = " ";
          on-click = "bash ~/.config/system_scripts/pkill_bc";
        };
      };
    };
  };
}
