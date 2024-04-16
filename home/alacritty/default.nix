{
  programs.alacritty = {
    enable = true;
    settings = {
      shell = "fish";
      cursor.style = "Block";
      env.TERM = "xterm-256color";
      font.size = 9.0;
      font.normal.family = "Noto Sans Mono";
      font.bold.family = "Noto Sans Mono";
      font.italic.family = "Noto Sans Mono";
      keyboard.bindings = [
        {
          chars = "\\u001B[13;2u";
          key = "Return";
          mods = "Shift";
        }
        {
          chars = "\\u001B[13;5u";
          key = "Return";
          mods = "Control";
        }
      ];
      colors = {
        indexed_colors = [
          {
            color = "#FAB387";
            index = 16;
          }
          {
            color = "#F5E0DC";
            index = 17;
          }
        ];
        bright = {
          black = "#585B70";
          blue = "#89B4FA";
          cyan = "#94E2D5";
          green = "#A6E3A1";
          magenta = "#F5C2E7";
          red = "#F38BA8";
          white = "#A6ADC8";
          yellow = "#F9E2AF";
        };
        cursor = {
          cursor = "#F5E0DC";
          text = "#1E1E2E";
        };
        dim = {
          black = "#45475A";
          blue = "#89B4FA";
          cyan = "#94E2D5";
          green = "#A6E3A1";
          magenta = "#F5C2E7";
          red = "#F38BA8";
          white = "#BAC2DE";
          yellow = "#F9E2AF";
        };
        hints = {
          end = {
            background = "#A6ADC8";
            foreground = "#1E1E2E";
          };
          start = {
            background = "#F9E2AF";
            foreground = "#1E1E2E";
          };
        };
        normal = {
          black = "#45475A";
          blue = "#89B4FA";
          cyan = "#94E2D5";
          green = "#A6E3A1";
          magenta = "#F5C2E7";
          red = "#F38BA8";
          white = "#BAC2DE";
          yellow = "#F9E2AF";
        };
        primary = {
          background = "#1E1E2E";
          bright_foreground = "#CDD6F4";
          dim_foreground = "#CDD6F4";
          foreground = "#CDD6F4";
        };
        search = {
          focused_match = {
            background = "#A6E3A1";
            foreground = "#1E1E2E";
          };
          matches = {
            background = "#A6ADC8";
            foreground = "#1E1E2E";
          };
        };
        selection = {
          background = "#F5E0DC";
          text = "#1E1E2E";
        };
        vi_mode_cursor = {
          cursor = "#B4BEFE";
          text = "#1E1E2E";
        };
      };
    };
  };
}
