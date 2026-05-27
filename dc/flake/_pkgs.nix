{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    neovim
    curl
    wget
    fish
  ];
}
