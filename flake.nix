{
  description = "sadOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { 
      self, 
      nixpkgs,
      deploy-rs,
      ...
    } @ inputs: let 
    inherit (self) outputs;
      vars = import ./vars.nix;

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
        nas01 = mkConfig ./dc/machines/nas/nas.nix;
      };

      deploy.nodes = {
        tc01 = {
          hostname = "tc01";
          profiles.system = {
            user = "sadzeih";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.tc01;
          };
        };
        tc02 = {
          hostname = "tc02";
          profiles.system = {
            user = "sadzeih";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.tc02;
          };
        };
        tc03 = {
          hostname = "tc03";
          profiles.system = {
            user = "sadzeih";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.tc03;
          };
        };
        nas01 = {
          hostname = "nas01";
          profiles.system = {
            user = "sadzeih";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.tc03;
          };
        };
      };
    };
}
