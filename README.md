# matesssaks dotfiles

## Installation

Install Nix using official installation script: https://nixos.org/download/ 

```bash
# Test Nix installation
nix-shell -p neofetch --run neofetch
# Close and reopen terminal

# Clone dotfiles repository
git clone https://github.com/matesssaks/dotfiles ~/.dotfiles
# Install Nix-darwin
sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --flake ~/.dotfiles/macos#default
# Close and reopen terminal
```

## Updating
```bash
git -C ~/.dotfiles pull --rebase
sudo darwin-rebuild switch --flake ~/.dotfiles/macos#default
```
