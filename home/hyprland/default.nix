{ config, pkgs, lib, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww-daemon &
    while true; do ${config.programs.waybar.package}/bin/waybar; done &
    ${config.programs.hjaltes-widgets.package}/bin/hjaltes-widgets volume-popup &

    sleep 1

    ${pkgs.swww}/bin/swww img ${config.wallpaper} &
  ''; 

  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";

  resizeSubmap = ''
    submap = resize

    binde = , H, resizeactive, -10  0
    binde = , J, resizeactive,  0   10
    binde = , K, resizeactive,  0  -10
    binde = , L, resizeactive,  10  0

    binde = SHIFT, H, resizeactive, -50  0
    binde = SHIFT, J, resizeactive,  0   50
    binde = SHIFT, K, resizeactive,  0  -50
    binde = SHIFT, L, resizeactive,  50  0

    bind = , escape, submap, reset
    bind = , A, submap, reset
    bind = , Q, submap, reset

    submap = reset
  '';
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

      extraConfig = ''
        ${resizeSubmap}
      '';

      settings = with config.colorScheme.palette; {
        exec-once ="${startupScript}/bin/start";

        monitor = map
          (m:
            let
              resolution = if m.resolution != null then m.resolution else "preferred"; 
              refreshRate = if m.refreshRate != null then "@${m.refreshRate}" else "";
              position = if m.position != null then m.position else "auto";
              hdr = if m.hdr then ", bitdepth, 10" else "";
              enable = if m.enable then "" else ", disabled";
            in 
            "${m.name}, ${resolution}${refreshRate}, ${position}, ${toString m.scale}${hdr}${enable}"
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
          "GDK_SCALE, 2"
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

        gestures = {
          workspace_swipe = true;
        };

        decoration = {
          rounding = 6;

          active_opacity = 0.875;
          inactive_opacity = 0.8;
          fullscreen_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 300;
            render_power = 4;
            offset = "0 40";
            scale = 0.9;
          };

          blur = {
            size = 12;
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
          "$mod, A, submap, resize"

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
