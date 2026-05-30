{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../base.nix
  ];

  boot = {
    initrd = {
      blacklistedKernelModules = ["mpt2sas"];
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod", "mpt3sas"];
      kernelModules = ["mpt3sas"];
    };
    extraModulePacks = [config.boot.kernelPackages.mpt3sas];
    kernelModules = ["kvm-intel"];
    kernelParams = ["pci=assign-busses" "pcie_ports=compat"];
  };
  
  fileSystems."/" = {
    device = "/dev/disk/by-label/nix";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
