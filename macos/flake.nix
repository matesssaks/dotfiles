{
	description = "matesssaks dotfiles";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
		nix-darwin = {
			url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		userconfig.url = "userconfig";
	};

	outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, userconfig }:
	let
		system = "aarch64-darwin";
	in {
		darwinConfigurations = {
			default = nix-darwin.lib.darwinSystem {
				inherit system;
				specialArgs = { inherit system inputs userconfig; };
				modules = [
					home-manager.darwinModules.home-manager
					./configuration.nix
				];
			};
		};
	};
}
