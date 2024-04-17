{ inputs, config, pkgs, ... }:

let
  startupScript = pkgs.writeShellScriptBin "start" ''
    ${config.programs.waybar.package}/bin/waybar &
    ${pkgs.swww}/bin/swww-daemon &

    sleep 1

    ${pkgs.swww}/bin/swww img $(../wallpaper.png) &
  ''; 

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

    bind = , catchall, submap, reset

    submap = reset
  '';
in { 
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    extraConfig = ''
      ${resizeSubmap}
    '';

    settings = {
      exec-once ="${startupScript}/bin/start";

      monitor = [
        "HDMI-A-2, 1920x1080, 0x0, 1"
        "DVI-D-1, 1920x1080, 1920x0, 1" 
      ];

      "$terminal" = "${config.programs.alacritty.package}/bin/alacritty";
      "$menu" = "${config.programs.wofi.package}/bin/wofi --show drun";
      "$screenshot" = "${pkgs.hyprshot}/bin/hyprshot --clipboard-only";

      env = [
        "XCURSOR_SIZE, 24"
        "XCURSOR_THEME, Bibata-Modern-Classic"
      ];

      input = {
        kb_layout = "dk";
        kb_variant = "nodeadkeys";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0.2;
      };

      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;

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
        gaps_in = 5;
        gaps_out = 10;

        border_size = 1;

        "col.active_border" = "rgba(dc6eefee) rgba(f47f94ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        allow_tearing = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      }; 

      master = {
        new_is_master = true;
      };

      misc = {
        force_default_wallpaper = 0;
      };

      windowrulev2 = [];

      workspace = [
        "1, monitor:HDMI-A-2"
      ];

      "$meta" = "SUPER";
      "$mod" = "ALT"; 

      bind = [
        # program shortcuts
        "$mod, Return, exec, $terminal"
        "$mod, R, exec, $menu"
        
        "$mod, Q, killactive,"
        "$mod, W, togglefloating,"
        "$mod, D, toggleopaque,"
        "$mod, F, fullscreen,"
        "$mod, P, pseudo,"
        "$mod, E, togglesplit,"
        "$mod, A, submap, resize"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # screenshot
        ", PRINT, exec, $screenshot -m output"
        "$mod, PRINT, exec, $screenshot -m window"
        "$mod SHIFT, PRINT, exec, $screenshot -m region"

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
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
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
}
