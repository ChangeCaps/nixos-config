{ config, pkgs, lib, ... }:

let
  cfg = config.audio;
in {
  options.audio = {
  };

  config = {
    # Set vm.swappiness to 10
    boot.kernel.sysctl."vm.swappiness" = 10;

    # Enable realtime scheduling
    boot.kernelParams = [ "threadirqs" ];

    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"   ; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio" ; type = "-"   ; value = "99"       ; }
      { domain = "@audio"; item = "nofile" ; type = "soft"; value = "99999"    ; }
      { domain = "@audio"; item = "nofile" ; type = "hard"; value = "99999"    ; }
    ];

    services.udev = {
      extraRules = ''
        KERNEL=="rtc0", group="audio"
        KERNEL=="hpet", group="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      raopOpenFirewall = true;

      extraConfig = {
        pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.rate"        = 48000;
            "default.clock.quantum"     = 64;
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 64;
            "link.max-buffers"          = 16;
          };

          "context.modules" = [
            {
              name = "libpipewire-module-rt";
              args = {
                "nice.level"   = -11;
                "rt.prio"      = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
              flags = [ "ifexists" "nofail" ];
            }
          ];
        };
      };  
    }; 
  };
}
