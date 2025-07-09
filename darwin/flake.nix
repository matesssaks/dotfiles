{
	description = "matesssaks dotfiles";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nix-darwin.url = "github:nix-darwin/nix-darwin/master";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs@{ self, nix-darwin, nixpkgs }:
	let
		configuration = { pkgs, ... }: {
			# Packages installed in system profile
			environment.systemPackages =
			[
				pkgs.git
				pkgs.neovim
				pkgs.firefox
				pkgs.kitty
			];

			# Enable flakes
			nix.settings.experimental-features = "nix-command flakes";

			# Enable zsh shell support in nix-darwin
			programs.zsh.enable = true;

			# Set Git commit hash for darwin-version
			system.configurationRevision = self.rev or self.dirtyRev or null;

			# Used for backwards compatibility, please read the changelog before changing
			# $ darwin-rebuild changelog
			system.stateVersion = 6;

			# The platform configuration
			nixpkgs.hostPlatform = "aarch64-darwin";
		};
	in {
		darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
			modules = [ configuration ];
		};
	};
}
