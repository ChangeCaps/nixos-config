{ config, pkgs, lib, inputs, ... }:

let
  widgets = inputs.hjaltes-widgets.packages.${pkgs.stdenv.hostPlatform.system}.default;

  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww-daemon &
    ${widgets}/bin/hjaltes-bar &
    ${widgets}/bin/hjaltes-notify &

    sleep 1

    ${pkgs.swww}/bin/swww img ${config.wallpaper} &
  ''; 

  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
in { 
  options = {
    wallpaper = lib.mkOption {
      type = with lib.types; path;
      default = ../../wallpaper/forest.webp;
      description = "The wallpaper to use";
    };

    keyboard = lib.mkOption {
      type = lib.types.str;
      description = "The primary keyboard";
    };
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = true;

      xwayland.enable = true;

      settings = with config.colorScheme.palette; {
        exec-once ="${startupScript}/bin/start";

        monitorv2 = map
          (m:
            let
              resolution = if m.resolution != null then m.resolution else "preferred";
              refreshRate = if m.refreshRate != null then "@${m.refreshRate}" else "";
            in
            {
              output = m.name;
              mode = "${resolution}${refreshRate}";
              position = if m.position != null then m.position else "auto";
              scale = m.scale;

              bitdepth = if m.hdr then 10 else 8;
              supports_wide_color = m.hdr;
              supports_hdr = m.hdr;
              cm = if m.hdr then "hdr" else null;
              sdrbrightness = 1.0;
              sdrsaturation = 1.0;
              sdr_min_luminance = 0.005;
              sdr_max_luminance = 200;
            }
           )
           config.monitors;

        "$terminal" = "${pkgs.kitty}/bin/kitty";
        "$menu" = "${pkgs.wofi}/bin/wofi --show drun";
        "$screenshot" = "${pkgs.hyprshot}/bin/hyprshot --clipboard-only";

        xwayland = {
          force_zero_scaling = true;
        };

        env = [
          "XCURSOR_SIZE, 24"
          "XCURSOR_THEME, Bibata-Modern-Classic"
          "GDK_SCALE, 1.5"
        ];

        input = {
          kb_layout = "us,dk";
          kb_options = "caps:escape";

          follow_mouse = 0;
          float_switch_override_focus = 0;

          touchpad = {
            natural_scroll = false;
          };

          repeat_rate = 40;
          repeat_delay = 250;

          sensitivity = 0.34;
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        experimental = {
          xx_color_management_v4 = true;
        };

        render = {
          send_content_type = true;
        };

        decoration = {
          rounding = 6;

          active_opacity = 0.875;
          inactive_opacity = 0.8;
          fullscreen_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 100;
            render_power = 4;
            offset = "0 40";
            scale = 0.9;
          };

          blur = {
            size = 16;
            passes = 2;
          };
        };

        animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        general = {
          gaps_in = 4;
          gaps_out = 8;

          border_size = 1;

          "col.active_border" = "rgba(${base0E}ee) rgba(${base08}ee) 45deg";
          "col.inactive_border" = "rgba(${base03}dd)";

          layout = "dwindle";

          allow_tearing = false;
        };

        group = {
          "col.border_active" = "rgba(${base0E}ee) rgba(${base08}ee) 45deg";
          "col.border_inactive" = "rgba(${base03}dd)";

          groupbar = {
            enabled = true;
            font_family = "Fira Mono Bold";
            font_size = 9;
            text_color = "rgba(${base06}ee)";

            gradients = true;

            "col.active" = "rgba(${base0E}44)";
            "col.inactive" = "rgba(${base03}44)";
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        }; 

        master = {};

        misc = {
          force_default_wallpaper = 0;
        };

        windowrulev2 = [
          "noinitialfocus,class:REAPER,title:^$"
        ];

        workspace = (builtins.genList 
          (x: let
            name = builtins.toString (x + 1);  
            monitor = lib.lists.findFirst (m: m.workspace == x + 1) null config.monitors;
            monitorOption = if monitor != null then ", monitor:${monitor.name}" else "";
          in 
          "${name}, persistent:true${monitorOption}")
          10
        );

        "$mod" = "SUPER"; 

        bind = [
          # program shortcuts
          "$mod, Return, exec, $terminal"
          "$mod, R, exec, $menu"
          
          "$mod, Q, killactive,"
          "$mod, W, togglefloating,"
          "$mod, D, exec, ${hyprctl} setprop active opaque toggle"
          "$mod, F, fullscreen,"
          "$mod, P, pseudo,"
          "$mod, E, togglesplit,"

          # switch keyboard layout
          "$mod, M, exec, ${hyprctl} switchxkblayout \"${config.keyboard}\" next"

          # Group shortcuts
          "$mod, G, togglegroup,"
          "$mod, TAB, changegroupactive, f"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # screenshot
          ", PRINT, exec, $screenshot -m output"
          "$mod, PRINT, exec, $screenshot -m window"
          "SHIFT, PRINT, exec, $screenshot -m region"

          # move focus
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, L, movewindow, r"

          "$mod, left,  movefocus, l"
          "$mod, down,  movefocus, d"
          "$mod, up,    movefocus, u"
          "$mod, right, movefocus, r"

          "$mod SHIFT, left,  movewindow, l"
          "$mod SHIFT, down,  movewindow, d"
          "$mod SHIFT, up,    movewindow, u"
          "$mod SHIFT, right, movewindow, r"

          # scroll workspace
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # volume control
          ", XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ", XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ", XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ", XF86AudioMicMute, exec, ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle"

          # media control 
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"

          # brightness control
          ", XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 10"
          ", XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 10"
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, focusworkspaceoncurrentmonitor, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)},activewindow"
              ]
            )
            10)
        );

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
