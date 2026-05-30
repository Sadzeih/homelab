{
  ...
}: {
	imports = [
		../../flake/types/cluster-node.nix
	];

	networking.hostName = "tc02";
	networking.interfaces.eno1.ipv4.addresses = [{
		address = "10.0.0.31";
		prefixLength = 24;
	}];
	networking.defaultGateway = "10.0.0.1";
	networking.nameservers = "1.1.1.1";
}
