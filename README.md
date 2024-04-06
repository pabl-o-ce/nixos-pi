# NixOS configuration RPi4
A NixOS configuration for the Raspberry Pi 4, featuring a custom setup for wireless networking, Docker, Hyprland, and more.

## Install

1. Ensure you have Nix installed on your system. You can follow the official Nix installation instructions.

2. Clone the NixOS configuration repository:
```sh
    git clone https://github.com/pabl-o-ce/nixos-pi.git
```
3. Navigate to the cloned repository directory:
```sh
    cd nixos-pi
```
4. Build and activate the NixOS configuration using flakes:
```sh
    sudo nixos-rebuild switch --flake .#pi
```

Note: Make sure you have write permissions for the microSD card and that you specify the correct device path to avoid data loss.

## Config

## Deployment
