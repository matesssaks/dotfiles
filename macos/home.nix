{ pkgs, config, lib, ...}: {
	# Fix showing apps in Spotlight and Apps
	targets.darwin.linkApps.enable = false; # Disable default app linking
	imports = [
		./apps-link.nix # Custom app linking fix
	];

	# Version Home Manager configuration is compatible with
	home.stateVersion = "25.05";

	# Let Home Manager manage itself
	programs.home-manager.enable = true;

	# User packages
	home.packages = [
		pkgs.hello
	];

	programs.firefox = {
		enable = true;
	};
}
