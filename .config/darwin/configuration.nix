{ pkgs, ... }:

{
  users.users.vasuadari = {
    name = "vadari";
    home = "/Users/vadari";
  };


  nix.settings.experimental-features = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nix.enable = false;
  system.stateVersion = 6;

  environment.systemPackages = with pkgs; [ colima docker ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;
  security.pam.services.sudo_local.watchIdAuth = true;

  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Bridge"
    "USB 10/100/1000 LAN"
  ];

  launchd = {
    user = {
      agents = {
        ollama-serve = {
          command = "${pkgs.ollama}/bin/ollama serve";
          serviceConfig = {
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/ollama_vasuadari.out.log";
            StandardErrorPath = "/tmp/ollama_vasuadari.err.log";
          };
        };
        colima-serve = {
          command = "${pkgs.colima}/bin/colima start --foreground";
          serviceConfig = {
            RunAtLoad = true;
            KeepAlive = true;
            StandardOutPath = "/tmp/colima_vasuadari.out.log";
            StandardErrorPath = "/tmp/colima_vasuadari.err.log";
            EnvironmentVariables = {
              PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
            };
          };
        };
      };
    };
  };

  launchd.daemons.dnsmasq = {
    command = "${pkgs.dnsmasq}/bin/dnsmasq --conf-file=/Users/vadari/.config/dnsmasq.conf";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };

  environment.launchDaemons.dnsmasq.enable = true;

  system.checks.verifyMacOSVersion = false;
  system.primaryUser = "vadari";
}
