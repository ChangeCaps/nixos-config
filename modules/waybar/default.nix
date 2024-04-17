{ inputs, config, pkgs, ... }: 
let 
  hyprland = config.wayland.windowManager.hyprland.package;
in {
  programs.waybar = {
    enable = true;

    style = builtins.readFile ./style.css;

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
          on-click = "${config.programs.wofi.package}/bin/wofi --show drun";
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
