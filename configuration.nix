{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "nixos";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  console = {
    keyMap = "jp106";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chooroo = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
    ];
    hashedPassword = "$6$eUzcZCQLFHu1GwgI$d4KfduxILHeA2JPoTwUbpSaMOKG.71GHePaJ0ovexBITGHi.vNJOEILYG95zS0yTTGqV4YtLVSsnXVk6vxXr.0";
    packages = with pkgs; [
      git
      neovim
    ];
  };

  system.stateVersion = "26.05";
}
