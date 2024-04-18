{ inputs, config, pkgs, ... }: 
let 
  hyprland = config.wayland.windowManager.hyprland.package;

  colors = with config.colorScheme.colors; ''
    @define-color base00 #${base00};
    @define-color base01 #${base01};
    @define-color base02 #${base02};
    @define-color base03 #${base03};
    @define-color base04 #${base04};
    @define-color base05 #${base05};
    @define-color base06 #${base06};
    @define-color base07 #${base07};
    @define-color base08 #${base08};
    @define-color base09 #${base09};
    @define-color base0A #${base0A};
    @define-color base0B #${base0B};
    @define-color base0C #${base0C};
    @define-color base0D #${base0D};
    @define-color base0E #${base0E};
    @define-color base0F #${base0F};
  '';
in {
  home.packages = with pkgs; [ 
    pkgs.playerctl
  ];

  programs.waybar = {
    enable = true;

    style = colors + builtins.readFile ./style.css;

    settings = {
      mainBar = {
        height = 39;

	      modules-left = [ 
          "custom/launcher" 
          "cpu" 
          "memory"
          "custom/media" 
        ];

	      modules-center = [ 
          "hyprland/workspaces" 
          "hyprland/window" 
          "hyprland/submap" 
        ];

	      modules-right = [
          "custom/updates" 
          "custom/wallpaper" 
          "backlight" 
          "pulseaudio" 
          "clock" 
          "battery" 
          "custom/power"
        ];

        "hyprland/workspaces" = {
          show-special = true;
          all-outputs = true;
          move-to-monitor = true;
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 50;
        };
	
	      pulseaudio = {
          tooltip = false;
          scroll-step =  5;
          format = "{icon}  {volume}%";
          format-muted = "  {volume}%";
          on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "${hyprland}/bin/hyprctl dispatch exec [floating] ${pkgs.pavucontrol}/bin/pavucontrol";
          format-icons = {
            default = [ "" "" "" ];
          };
        };

        network = {
          tooltip = false;
          format-wifi = "  {essid}";
          format-ethernet = "";
        };

        backlight = {
          tooltip = false;
          format =  " {}%";
          interval = 1;
          on-scroll-up = "light -A 5";
          on-scroll-down = "light -U 5";
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };

          format = "{icon}  {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt =  "{time} {icon}";
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
          format = " {}%";
          max-length = 10;
        };

        memory = {
          interval = 30;
          format = " {}%";
          max-length = 10;
        };

        "custom/media" = {
          restart-interval = 30;
          format = "{icon} {}";
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
          on-click = "${pkgs.wofi.package}/bin/wofi --show drun";
          on-click-right = "${pkgs.killall}/bin/killall .wofi-wrapped";
        };

        "custom/power" = {
          format = " ";
          on-click = "${pkgs.wlogout}/bin/wlogout";
        };

        "custom/wallpaper" = {
          format = " ";
          on-click = "bash ~/.config/system_scripts/pkill_bc";
        };
      };
    };
  };
}
