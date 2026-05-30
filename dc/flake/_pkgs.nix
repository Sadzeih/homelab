{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    neovim
    curl
    wget
    fish
    htop
    pciutils
    lsiutil
    megacli
    zip
    unzip
  ];
}
