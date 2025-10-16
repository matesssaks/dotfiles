{ pkgs, config, system, inputs, userconfig, ... }: {
	# Set Home Manager
	users.users.${userconfig.username}.home = "/Users/${userconfig.username}";
	home-manager = {
		extraSpecialArgs = { inherit system inputs userconfig; };
		useGlobalPkgs = true;
		useUserPackages = true;

		users.${userconfig.username} = import ./home.nix;
	};

	# Enable flakes
	nix.settings.experimental-features = ["nix-command" "flakes"];

	# Set Git commit hash for darwin-version
	system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

	# Used for backwards compatibility, please read the changelog before changing
	# $ darwin-rebuild changelog
	system.stateVersion = 6;

	# The platform configuration
	nixpkgs.hostPlatform = system;

	# Enable zsh shell support in nix-darwin
	programs.zsh.enable = true;

	# Packages installed in system profile
	environment.systemPackages =
	[
		pkgs.git
		pkgs.neovim
	];
}
