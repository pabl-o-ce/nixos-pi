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

Note: Make sure you have write permissions for the microSD card and that you specify the correct device path to avoid data loss.

## Config

1. Add variables in the `hosts/pi/default.nix`:
```nix
# Define variables
let
  user = "user";
  hashedPassword = "$y$j9T$S6GQmMWVSaLC9akC6aPcd1$3HV1XwIjUAR18ZwEriXXw3MRu/PUHld7lAFRsY1R.KA";
  SSID = "example";
  SSIDpassword = "example";
  interface = "wlan0";
  hostname = "example";
  ip = "10.0.0.4"
  ipGateway = "10.0.0.1"
  dns1 = "1.1.1.3"
  dns2 = "1.0.0.3"
```

## Deployment

1. Build and activate the NixOS configuration using flakes:
```sh
    sudo nixos-rebuild switch --flake .#pi
```
