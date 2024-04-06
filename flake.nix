{
  # Define the inputs section, specifying the sources of packages and modules
  inputs = {
    # Use the nixpkgs repository from the "nixos-unstable" branch on GitHub
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Use the NixOS Hardware repository from GitHub
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  # Define the outputs section, which will contain the resulting NixOS configuration
  outputs = inputs:
    # Create an attribute set with the inputs attribute set inherited
    { inherit inputs; }
    # Add a new attribute set named "nixosConfigurations"
    let
      specialArgs = { inherit inputs; };
    in {
      nixosConfigurations = {
        # Define a NixOS configuration for a Raspberry Pi system named "pi"
        pi = nixpkgs.lib.nixosSystem {
          # Inherit the specialArgs attribute set
          inherit specialArgs;
          # Specify the target system architecture
          system = "aarch64-linux";
          # Specify the list of modules to use for the configuration
          modules = [
            # Use the hardware-specific module for Raspberry Pi 4 from nixos-hardware
            nixos-hardware.nixosModules.raspberry-pi-4
            # Use a custom module located in the relative path ./hosts/pi
            ./hosts/pi
          ];
        };
      };
    };
}
