{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  console.keyMap = "jp106";

  users.users.chooroo = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    hashedPassword = "$6$eUzcZCQLFHu1GwgI$d4KfduxILHeA2JPoTwUbpSaMOKG.71GHePaJ0ovexBITGHi.vNJOEILYG95zS0yTTGqV4YtLVSsnXVk6vxXr.0";
    packages = with pkgs; [
      neovim
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
      AllowUsers = [ "chooroo" ];
      X11Forwarding = false;
    };
  };

  system.stateVersion = "26.05";

  services.xserver = {
    enable = true;

    xkb = {
      layout = "jp";
      model = "jp106";
    };

    windowManager.i3 = {
      enable = true;
    };

    displayManager.defaultSession = "none+i3";
  };
}
