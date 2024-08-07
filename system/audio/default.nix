{ config, pkgs, lib, ... }:

let
  cfg = config.audio;
in {
  options.audio = {
  };

  config = {
    # Set vm.swappiness to 10
    boot.kernel.sysctl."vm.swappiness" = 10;

    services.udev = {
      extraRules = ''
        KERNEL=="rtc0", group="audio"
        KERNEL=="hpet", group="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
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
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 128;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 128;
          };
        };
      };  
    }; 
  };
}
