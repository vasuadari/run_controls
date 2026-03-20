{ pkgs, ... }:

{
  users.users.vasuadari = {
    name = "vasu.adari";
    home = "/Users/vasu.adari";
  };


  nix.settings.experimental-features = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nix.enable = false;
  system.stateVersion = 6;

  environment.systemPackages = with pkgs; [ dnsmasq colima docker ];

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
  networking.dns = [ "127.0.0.1" "1.1.1.1" ];

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
    command = "${pkgs.dnsmasq}/bin/dnsmasq --conf-file=/Users/vasu.adari/.config/dnsmasq.conf";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };

  environment.launchDaemons.dnsmasq.enable = true;

  system.checks.verifyMacOSVersion = false;
  system.primaryUser = "vasu.adari";
}
