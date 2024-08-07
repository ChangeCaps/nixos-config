{ inputs, config, pkgs, ... }: 

{
  config = {
    services.dunst = {
      enable = true;
      settings = with config.colorScheme.palette; {
        global = {
          frame_color = "#${base05}";
          separator_color = "frame";
          font = "JetBrains Mono Regular 11";
          corner_radius = 10;
          offset = "5x5";
          origin = "top-right";
          notification_limit = 8;
          gap_size = 7;
          frame_width = 2;
          width = 300;
          height = 100;
        };

        urgency_low = {
          background = "#${base00}";
          foreground = "#${base05}";
        };

        urgency_normal = {
          background = "#${base00}";
          foreground = "#${base05}";
        };

        urgency_critical = {
          background = "#${base00}";
          foreground = "#${base05}";
          frame_color = "#${base08}";
        };
      };
    };
  };
}
