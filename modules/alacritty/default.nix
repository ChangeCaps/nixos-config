{ inputs, config, pkgs, lib, ... }: 

{
  options.alacritty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable alacritty";
    };
  };

  config = {
    programs.alacritty = {
      enable = config.alacritty.enable;

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

        colors = with config.colorScheme.colors; {
          bright = {
            black = "0x${base00}";
            blue = "0x${base0D}";
            cyan = "0x${base0C}";
            green = "0x${base0B}";
            magenta = "0x${base0E}";
            red = "0x${base08}";
            white = "0x${base06}";
            yellow = "0x${base09}";
          };
          cursor = {
            cursor = "0x${base06}";
            text = "0x${base06}";
          };
          normal = {
            black = "0x${base00}";
            blue = "0x${base0D}";
            cyan = "0x${base0C}";
            green = "0x${base0B}";
            magenta = "0x${base0E}";
            red = "0x${base08}";
            white = "0x${base06}";
            yellow = "0x${base09}";
          };
          primary = {
            background = "0x${base00}";
            foreground = "0x${base06}";
          };
        };
      };
    };
  };
}
