{
  description = "sadOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
  };

  outputs = { 
      self, 
      nixpkgs,
      ...
    } @ inputs: let 
    inherit (self) outputs;
      mkConfig = path:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs outputs vars;};
          modules = [
            path
          ];
        };

    in {
      nixosConfigurations = {
        clusterNode = mkConfig ./dc/flake/types/cluster-node.nix;
      };
    };
}
