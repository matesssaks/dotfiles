{
	description = "matesssaks dotfiles";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
		nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs@{ self, nix-darwin, nixpkgs }:
	let
		configuration = { pkgs, config, ... }: {
			# Packages installed in system profile
			environment.systemPackages =
			[
				pkgs.git
				pkgs.neovim
				pkgs.firefox
				pkgs.kitty
				pkgs.mkalias
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

			# Make apps show up in spotlight
			system.activationScripts.applications.text = let
				env = pkgs.buildEnv {
					name = "system-applications";
					paths = config.environment.systemPackages;
					pathsToLink = "/Applications";
				};
			in
				pkgs.lib.mkForce ''
					rm -rf /Applications/Nix\ Apps
					mkdir -p /Applications/Nix\ Apps
					find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + | while read -r src; do
						app_name=$(basename "$src")
						${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
					done
				'';
		};
	in {
		darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
			modules = [ configuration ];
		};
	};
}
