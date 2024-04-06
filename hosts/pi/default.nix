{
  config,
  pkgs,
  lib,
  ...
}:
# Define variables
let
  user = "user";
  hashedPassword = "$y$j9T$S6GQmMWVSaLC9akC6aPcd1$3HV1XwIjUAR18ZwEriXXw3MRu/PUHld7lAFRsY1R.KA";
  SSID = "example";
  SSIDpassword = "example";
  interface = "wlan0";
  hostname = "example";
  ip = "10.0.0.4";
  ipGateway = "10.0.0.1";
  dns = ["1.1.1.3" "1.0.0.3"];
  tcpPort = [22 53 80 443];
  udpPort = [53];
in {
  
  # Disable default imports
  imports = [];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      # Enable experimental features in Waybar
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
        });
      })
    ];
  };

  # Nix configuration
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  # Boot configuration
  boot = {
    # Use Linux kernel packages for Raspberry Pi 4
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

    # Specify available kernel modules
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];

    # Use generic-extlinux-compatible loader instead of GRUB
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    # Set sysctl parameters
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 0;
    };
  };

  # File system configuration
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  # Networking configuration
  networking = {
    # Enable nftables
    nftables.enable = true;

    # Firewall settings
    firewall = {
      enable = true;
      allowedTCPPorts = tcpPort;
      allowedUDPPorts = udpPort;
    };

    # Set hostname and extra hosts
    hostName = hostname;
    extraHosts = ''
      ${ip} ${hostname}.local
    '';

    # Wireless network settings
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [interface];
    };

    # Disable dhcpcd
    dhcpcd.enable = false;

    # Interface configuration
    interfaces = {
      end0.useDHCP = false;
      end0.ipv4.addresses = [
        {
          address = ip;
          prefixLength = 24;
        }
      ];
    };

    # Default gateway and nameservers
    defaultGateway = ipGateway;
    nameservers = dns;
  };
  
  # Set available shells
  environment.shells = with pkgs; [zsh];

  # Install additional system packages
  environment.systemPackages = with pkgs; [
    btop
    dconf
    docker
    docker-compose
    git
    hyprland
    libraspberrypi
    lsd
    meslo-lgs-nf
    meson
    neofetch
    neovim
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    pulseaudio
    raspberrypi-eeprom
    swww
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    wofi
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    zsh
  ];

  # Hint Electon apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Docker configuration
  virtualisation.docker.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Services configuration
  services = {
    # Enable OpenSSH server
    openssh.enable = true;
    # Enable SDDM display manager for Wayland
    xserver.displayManager.sddm.wayland.enable = true;
  };

  # Polkit configuration
  security = {
    polkit.enable = true;
  };

  # User configuration
  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users."${user}" = {
      inherit hashedPassword;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [];
      extraGroups = ["wheel" "docker"];
    };
  };

  # Sound configuration (commented out)
  # sound.enable = true;

  # Hardware configuration
  hardware = {
    # Enable device tree overlays for Raspberry Pi 4
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    # Enable device tree
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };

    # Enable FKMS 3D driver (commented out)
    # raspberry-pi."4".fkms-3d.enable = true;

    # Enable PulseAudio and audio support (commented out)
    # pulseaudio.enable = true;
    # raspberry-pi."4".audio.enable = true;

    # Enable redistributable firmware
    enableRedistributableFirmware = true;
  };

  # Programs configuration
  programs = {
    # Enable dconf
    dconf.enable = true;

    # Enable Hyprland and XWayland
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Enable Zsh
    zsh.enable = true;
  };

  # NixOS state version
  system.stateVersion = "23.11";
}
