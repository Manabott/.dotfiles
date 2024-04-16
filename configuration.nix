# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # zsh default
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    layout = "za";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manabot = {
    isNormalUser = true;
    description = "manabot";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  hyprland
  swww
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  xwayland
  meson
  wayland-protocols
  wayland-utils
  wl-clipboard
  wlroots
  pavucontrol
  pipewire
  firefox
  dunst
  libnotify
  git
  spotify
  kitty
  networkmanagerapplet
  emacs
  wofi
  gtk3
  foot
  waybar
  nightfox-gtk-theme
  sddm
  libsForQt5.sddm
  sddm-chili-theme
  ripgrep
  findutils
  emacsPackages.undo-fu
  coreutils
  fd
  clang
  ];
  
  # Nvidia stuff
  hardware.opengl = {
     enable = true;
     driSupport = true;
     driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  
  # Enable hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
    
  # Enable SDDM Window Managers
  services.xserver.displayManager.sddm = {
  enable = true;
  # services.xerserver.enable = true;
  };
  
  # enable xserver
  services.xserver.enable = true;
 
  # Enable GTK
  # programs.gtk.enable = true;
  
  # gtk.theme.package = pkgs.nightfox-gtk-theme;
  # gtk.theme.name = "nightfox";

  # Hint Electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE= "1";
   };

  # Screenshare enable
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
   }; 
  
  # Fix waybar not displaying in workspaces
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  # Fix emacs not displaying
  services.emacs.package = pkgs.emacs-unstable;
 
#  nixpkgs.overlays = [
#    (import (builtins.fetchTarball {
#      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
#     }))
#   ];


  # Nerd fonts
  fonts.fonts = with pkgs; [
    nerdfonts
    meslo-lgs-nf
  ];
  
  # Fix sound?
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  }; 

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Disable SSH Askpass
  programs.ssh.askPassword = "";

}
