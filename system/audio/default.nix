{ config, pkgs, lib, ... }:

let
  cfg = config.rt-audio;
  sample-rate = 48000;
  quantum = 64;
in {
  options.rt-audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable real-time audio configuration";
    };
  };

  config = lib.recursiveUpdate {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  } (lib.mkIf cfg.enable {
    # Set vm.swappiness to 10
    boot.kernel.sysctl."vm.swappiness" = 10;

    # Enable realtime scheduling
    boot.kernelParams = [ "threadirqs" ];

    boot.kernelPackages = pkgs.linuxPackages_latest_rt;

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

    services.das_watchdog.enable = lib.mkForce true;

    security.rtkit.enable = true;

    services.pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      extraConfig = {
        pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.rate"        = sample-rate;
            "default.clock.quantum"     = quantum;
            "default.clock.min-quantum" = quantum;
            "default.clock.max-quantum" = quantum;
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

        #pipewire-pulse."92-low-latency" = {
        #  "context.modules" = [
        #    {
        #      name = "libpipewire-module-protocol-pulse";
        #      args = {
        #        "pulse.default.req" = quantum-fraction;
        #        "pulse.min.req"     = quantum-fraction;
        #        "pulse.max.req"     = quantum-fraction;
        #        "pulse.min.quantum" = quantum-fraction;
        #        "pulse.max.quantum" = quantum-fraction;
        #      };
        #    }
        #  ];
        #
        #  "stream.properties" = {
        #    "node.latency" = quantum-fraction;
        #    "resample.quality" = 1;
        #  };
        #};
      };  
    }; 

    services.pipewire.wireplumber.extraConfig."99-alsa-lowlatency" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "node.name" = "~alsa_output.*";
            }
          ];
          actions = {
            update-props = {
              "audio.rate"             = sample-rate;
              "api.alsa.period-size"   = quantum / 2;
              "api.alsa.disable-batch" = false;
            };
          };
        }
      ];
    };
  });
}
