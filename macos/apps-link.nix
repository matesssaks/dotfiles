{ pkgs, config, lib, ... }: {
	# Need to copy the apps because otherwise spotlight does not find them.
	home.activation = {
		linkHomeManagerApps = lib.hm.dag.entryAfter ["linkGeneration"] ''
			# Create directory for the applications
			mkdir -p "$HOME/Applications/Nix-Apps"

			# Remove old entries
			rm -rf "$HOME/Applications/Nix-Apps"/*

			# Link each application
			for source_dir in "${config.home.path}/Applications"/*; do
				if [ -d "$source_dir" ] || [ -L "$source_dir" ]; then

					# Get app name and target directory
					app_name=$(basename "$source_dir")
					target_dir="$HOME/Applications/Nix-Apps/$app_name"

					# Create the required structure
					mkdir -p "$target_dir/Contents"

					# Copy the Info.plist file
					if [ -f "$source_dir/Contents/Info.plist" ]; then
						cp -f "$source_dir/Contents/Info.plist" "$target_dir/Contents/"
					fi

					# Copy the icon files and symlink other resources
					if [ -d "$source_dir/Contents/Resources" ]; then
						mkdir "$target_dir/Contents/Resources"
						for resource in "$source_dir/Contents/Resources/"*; do
							resource_name=$(basename "$resource")
							if [[ "$resource_name" == *.icns ]]; then
								cp -f "$resource" "$target_dir/Contents/Resources/$resource_name"
							else
								ln -sfn "$resource" "$target_dir/Contents/Resources/$resource_name"
							fi
						done
					fi

					# Symlink rest of the files
					for file in "$source_dir/Contents"/*; do
						file_name=$(basename "$file")
						if [ "$file_name" != "Info.plist" ] && [ "$file_name" != "Resources" ]; then
							ln -sfn "$file" "$target_dir/Contents/$file_name"
						fi
					done
				fi
			done
		'';
	};
}
