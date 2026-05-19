# Define disk
DISK="/dev/sda"
DISK_BOOT_PARTITION="/dev/sda1"
DISK_NIX_PARTITION="/dev/sda2"

# Display warning and wait for confirmation to proceed
echo -e "\n\033[1;31m**Warning:** This script is irreversible and will prepare system for NixOS installation.\033[0m"
read -n 1 -s -r -p "Press any key to continue or Ctrl+C to abort..."

# Clear screen before showing disk layout
clear

# Display disk layout
echo -e "\n\033[1mDisk Layout:\033[0m"
lsblk
echo ""

# Undo any previous changes if applicable
echo -e "\n\033[1mUndoing any previous changes...\033[0m"
set +e
umount -R /mnt
set -e
echo -e "\033[32mPrevious changes undone.\033[0m"

# Partitioning disk
echo -e "\n\033[1mPartitioning disk...\033[0m"
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 513MiB
parted $DISK -- set 1 boot on
parted $DISK -- mkpart linux-swap 513MiB 4417MiB
parted $DISK -- mkpart Nix 4417MiB 100%
echo -e "\033[32mDisk partitioned successfully.\033[0m"

# Creating filesystems
echo -e "\n\033[1mCreating filesystems...\033[0m"
mkfs.fat -F32 -n boot $DISK_BOOT_PARTITION
mkfs.ext4 -F -L nix -m 0 $DISK_NIX_PARTITION
# Let mkfs catch its breath
sleep 2
echo -e "\033[32mFilesystems created successfully.\033[0m"

# Mounting filesystems
echo -e "\n\033[1mMounting filesystems...\033[0m"
mount /dev/disk/by-label/nix /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
echo -e "\033[32mFilesystems mounted successfully.\033[0m"

# Generating initrd SSH host key
echo -e "\n\033[1mGenerating initrd SSH host key...\033[0m"
ssh-keygen -t ed25519 -N "" -C "" -f /mnt/nix/secret/initrd/ssh_host_ed25519_key
echo -e "\033[32mSSH host key generated successfully.\033[0m"

# Creating public age key for sops-nix
echo -e "\n\033[1mConverting initrd public SSH host key into public age key for sops-nix...\033[0m"
sudo nix-shell --extra-experimental-features flakes -p ssh-to-age --run 'cat /mnt/nix/secret/initrd/ssh_host_ed25519_key.pub | ssh-to-age'
echo -e "\033[32mAge public key generated successfully.\033[0m"

# Completed
echo -e "\n\033[1;32mAll steps completed successfully. NixOS is now ready to be installed.\033[0m\n"
echo -e "To install NixOS configuration for hostname, run the following command:\n"
echo -e "\033[1msudo nixos-install --root /mnt --flake github:Sadzeih/homelab#clusterNode\033[0m\n"
