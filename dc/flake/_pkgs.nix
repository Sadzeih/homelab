{pkgs, ...}: {
  environments.systemPackages = with pkgs; [
    efibootmgr
    git
    neovim
    curl
    wget
    fish
  ]
}
