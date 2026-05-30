{
  ...
}: {
	imports = [
		../../flake/types/cluster-node.nix
	];

	networking.hostName = "tc03";
	networking.interfaces.eno1.ipv4.addresses = [{
		address = "10.0.0.32";
		prefixLength = 32;
	}];
}
