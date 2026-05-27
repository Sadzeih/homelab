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
      vars = import "./vars.nix";

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
        # ThinkCenter Cluster Nodes
        tc01 = mkConfig ./dc/machines/cluster/tc01.nix;
        tc02 = mkConfig ./dc/machines/cluster/tc02.nix;
        tc03 = mkConfig ./dc/machines/cluster/tc03.nix;
      };
    };
}
