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
sudo nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --flake ~/.dotfiles/darwin#default
#Close and reopen terminal
```

## Updating
```bash
git -C ~/.dotfiles pull
darwin-rebuild switch --flake ~/.dotfiles/darwin#default
```
