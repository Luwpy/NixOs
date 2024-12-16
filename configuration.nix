{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot loader configuration
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
  };

  # Networking
  networking.hostName = "amd-pc";
  networking.networkmanager.enable = true; # NetworkManager is enabled for Wi-Fi management, consider disabling if primarily using wired connections.

  # Timezone and locale
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Keyboard layout
  services.xserver = {
    enable = true; # X11 is enabled for compatibility, but since Hyprland uses Wayland, review if X11 support is necessary.
    xkb.layout = "br";
  };

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true; # Ensure ALSA compatibility
    wireplumber.enable = true;
  };

  # Nix configuration
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # User configuration
  users.users.luwpy = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "input"]; # Enables sudo, video acceleration, and input support
    packages = with pkgs; [ tree ];
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Development Tools
    neovim
    vscode
    helix
    alejandra
    nixd
    zed-editor
    git

    # Browsers and Internet Tools
    firefox
    discord

    # Wayland and Desktop Environment Tools
    hyprland
    swaybg
    waybar
    wofi
    rofi
    dunst
    xorg.xset
    xorg.xrandr
    vesktop

    # Audio and Multimedia
    pavucontrol
    grim
    slurp

    # Utilities
    wget
    kitty
    zsh
    starship
    xdg-utils
    gtk3
    gtk4
    libsForQt5.qt5ct
    qt6ct

    # Virtualization and Emulation
    qemu
    quickemu

    # System Tools
    steam
    glxinfo
    libGL
    libglvnd
    libdrm
    vulkan-tools
    mesa
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ mesa libGL libglvnd libdrm vulkan-tools ]; # Consider enabling Vulkan support for better compatibility with Wayland and Hyprland.
  };

  hardware.enableAllFirmware = true;

  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"]; # Ensure your GPU supports the AMDGPU driver to avoid boot issues.

  environment.variables = {
    STEAM_RUNTIME = "1"; # Specific to Steam
    XDG_CURRENT_DESKTOP = "Hyprland"; # Hyprland specific environment variable
    GTK_THEME = "Adwaita-dark"; # GTK apps theming
    QT_QPA_PLATFORMTHEME = "qt5ct"; # QT5 configuration tool
    QT_STYLE_OVERRIDE = "Adwaita-Dark"; # Override QT style
    XCURSOR_THEME = "Adwaita"; # Cursor theming
    XCURSOR_SIZE = "24"; # Cursor size
    WAYLAND_DISPLAY = "wayland-0"; # Wayland display identifier
    MOZ_ENABLE_WAYLAND = "1"; # Ensures Firefox runs in Wayland mode
  };

  # Desktop environment / Hyprland configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # Enable XWayland for legacy X11 apps. Remove if no X11 apps are required.
  };

  # XDG Desktop Portals for better Wayland support
  xdg.portal.enable = true;

  # OpenSSH service
  services.openssh.enable = true;

  # Printing (optional)
  services.printing.enable = true;

  # Display Manager and Greeter
  services.displayManager = {

    defaultSession = "hyprland";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "luwpy";
      };
    };
  };

  # Programs
  programs.git.enable = true;
  programs.zsh.enable = true;

  # State version - Do NOT change this unless you are upgrading versions
  system.stateVersion = "25.05";
}
