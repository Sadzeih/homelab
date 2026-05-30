{
  inputs,
  config,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./_pkgs.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    timeout = 10;
  };

  # allows unfree packages (proprietary)
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };
  
  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
  };
  
  # inspo: https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
    };
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
    };
    fstrim.enable = true;
  };

  time.timeZone = "Europe/Paris";
  zramSwap.enable = true;

  programs.fish.enable = true;

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        vars.sshPublicKey
      ];
    };
    sadzeih = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      openssh.authorizedKeys.keys = [
        vars.sshPublicKey
      ];
      shell = pkgs.fish;
    };
  };
}
