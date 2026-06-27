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
      "networkmanager"
      "video"
      "input"
    ];
    hashedPassword = "$6$eUzcZCQLFHu1GwgI$d4KfduxILHeA2JPoTwUbpSaMOKG.71GHePaJ0ovexBITGHi.vNJOEILYG95zS0yTTGqV4YtLVSsnXVk6vxXr.0";
    packages = with pkgs; [
      git
      neovim
    ];
  };

  # OpenGL / DRI / Mesa 周り。
  # X11自体の必須ではないが、glxinfo / glxgears で描画経路を見るために有効化。
  hardware.graphics.enable = true;

  # X11学習用。
  services.xserver = {
    enable = true;

    # 起動時に勝手にGUIへ行かせない。
    # TTYでログインして、自分で `startx` を叩く。
    autorun = false;

    # JP配列。console.keyMapとは別で、X11側のキーボード設定。
    xkb = {
      layout = "jp";
      model = "jp106";
    };

    # display managerなしで、TTYから手動でXorgを起動するための設定。
    # LightDM/GDM/SDDMを挟まないので、Xorg起動の流れを観察しやすい。
    displayManager = {
      startx.enable = true;
      lightdm.enable = lib.mkForce false;
    };

    # Window Manager。
    # X server と WM は別物だと理解しやすいよう、Desktop Environmentではなくi3のみ。
    windowManager.i3 = {
      enable = true;

      extraPackages = with pkgs; [
        dmenu
        i3status
        xterm
      ];

　　　　configFile = pkgs.writeText "i3-x11-learning.conf" ''
　　　　  # VirtualBox on Wayland/Niri host では Super/Mod4 がホスト側に奪われやすい。
  　　　　# ゲスト内のi3操作は Alt(Mod1) に逃がす。
  　　　　set $mod Mod1

  　　　　font pango:monospace 10

  　　　　floating_modifier $mod

  　　　　bindsym $mod+Return exec xterm
  　　　　bindsym $mod+d exec dmenu_run
  　　　　bindsym $mod+Shift+q kill
  　　　　bindsym $mod+Shift+r restart
  　　　　bindsym $mod+Shift+e exit

  　　　　bindsym $mod+h focus left
  　　　　bindsym $mod+j focus down
  　　　　bindsym $mod+k focus up
  　　　　bindsym $mod+l focus right

  　　　　bindsym $mod+Shift+h move left
  　　　　bindsym $mod+Shift+j move down
  　　　　bindsym $mod+Shift+k move up
  　　　　bindsym $mod+Shift+l move right

  　　　　bindsym $mod+f fullscreen toggle

  　　　　bar {
    　　　　status_command i3status
  　　　　}
　　　　'';
    };
  };

  # startxセッションの既定。
  # NixOSの世代によって option 名の移動があるが、25系では services.displayManager.defaultSession が使える。
  services.displayManager.defaultSession = "none+i3";

  environment.systemPackages =
    (with pkgs; [
      # 基本観察
      xterm
      lsof
      strace
      procps
      psmisc
      pciutils
      usbutils

      # Window Manager操作・EWMH観察
      wmctrl
      xdotool

      # OpenGL / GLX / DRI観察
      mesa-demos

      # 任意: X11 protocol proxy/tracer。
      # nixpkgsに存在する場合だけ入れる。
    ])
    ++ (with pkgs.xorg; [
      # X起動・認証
      xinit
      xauth
      xhost

      # X server情報
      xdpyinfo
      xrandr
      xset
      xsetroot

      # window / property / atom観察
      xwininfo
      xprop
      xlsclients
      xlsatoms

      # input / keyboard観察
      xev
      xinput
      xmodmap
      setxkbmap
      xkbcomp

      # 小さいX client
      xeyes
      xclock
      xmessage
      xkill
    ])
    ++ lib.optional (builtins.hasAttr "xscope" pkgs.xorg) pkgs.xorg.xscope
    ++ lib.optional (builtins.hasAttr "xtrace" pkgs) pkgs.xtrace;

  system.stateVersion = "26.05";

  # 外部からSSH接続できるようにする。
  # 例:
  #   ssh chooroo@<このNixOSマシンのIPアドレス>
  services.openssh = {
    enable = true;

    # SSHの待受ポート。
    ports = [ 22 ];

    # OpenSSH用のポートをNixOS firewallで自動開放する。
    # デフォルトでも true だが、学習用に明示。
    openFirewall = true;

    settings = {
      # パスワードログインを許可。
      # すでに chooroo に hashedPassword があるので、そのパスワードで入れる。
      PasswordAuthentication = true;

      # keyboard-interactive 認証も許可。
      # sshd 側で password / keyboard-interactive が絡むので明示しておく。
      KbdInteractiveAuthentication = true;

      # root直ログインは禁止。
      PermitRootLogin = "no";

      # SSHログインできるユーザーを chooroo に限定。
      AllowUsers = [ "chooroo" ];

      # X11転送は不要なら切る。
      X11Forwarding = false;
    };
  };
}
