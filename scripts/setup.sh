
# Todo: add automatic partinioning and formating of hard drive

# Install flakes and build system 
nix-shell -p nixUnstable --command "nixos-install --flake .#${HOSTNAME}"
