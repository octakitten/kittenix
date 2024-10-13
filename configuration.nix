# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
 
{ config, pkgs, ... }:
 
let
  unstableTarball = (
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    });
/* 
  nixvim = import (fetchGit {
      url = "https://github.com/nix-community/nixvim";
  });
 
  catppuccin = import (fetchGit {
    url = "github:catppuccin/nix";
  });
*/
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
/*
      nixvim.nixosModules.nixvim
      catppuccin.nixosModules.catppuccin
*/
    ];
 
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
 
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
 
  networking.hostName = "kittenixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
 
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
 
  # Enable networking
  networking.networkmanager.enable = true;
/*
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
*/
/*
  system.autoUpgrade = {
    enable = true;
    operation = "boot";
    dates = "weekly";
  };
*/
  # Set your time zone.
  time.timeZone = "America/New_York";
 
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
 
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
 
  # Enable the X11 windowing system.
  services.xserver.enable = true;
 
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    };
 
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    #videoDrivers = ["nvidia"];
  };
/*
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
 
  hardware.opengl = {
    enable = true;
  };
*/
  # Enable CUPS to print documents.
  services.printing.enable = true;
 
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
 
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
 
  # sound and audio packages
/*
  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
  ];
*/
  #services.flatpak.enable = true;
  # TODO: double check whether this works properly
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
 
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.octa = {
    isNormalUser = true;
    description = "octa";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
 
  # set theme here
/*
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
*/
 
  #exclude gnome packages here
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    ]) ++ (with pkgs.gnome; [
    gnome-music
    geary
    totem
    tali
    iagno
    hitori
    atomix
    ]);
 
  #configure gnome settings
/*
  dconf.settings = {
    enable = true;
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
    };
  };
*/ 

  # general purpose packages and apps
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    thunderbird
    discord
    firefox
    mpv-unwrapped
    gcc
    clang
    neovim
    git
    python312Full
    vscodium
/*
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
      # TODO: put in some vscode extensions
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ {} ];
    })
*/
    #spotify
    #obsidian
    #libreoffice-qt
    #hunspell
    #hunspellDicts.en_US
    # TODO: wish-list of packages that i need to look into:
    #appimage
    #vscode
    #parsec
    #manuskript
    #krita
    #gnu-octave
    #emacs
    #huion-drivers
    #qbittorent
    #vesktop
  ];
/* 
  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      }
    );

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
    };
  };
*/ 
  # fonts
  fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "ComicShannsMono" ]; })
  ];
 
  # desktop environment
/*
  environment.systemPackages = with pkgs; [
    pyprland
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
    cool-retro-term
    starship
    helix
    qutebrowser
    zathura
    imv
  ];
*/
  # coding-relevant
/* 
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        background = {
          light = "macchiato";
          dark = "mocha";
        };
        flavour = "mocha";
        integrations = {
          gitsigns = true;
          illuminate = {
            enabled = true;
            lsp = true;
          };
          treesitter = true;
          telescope.enabled = true;
          indent_blankline.enabled = true;
        };
      };
    };
    plugins = {
      treesitter = {
        enable = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
      undotree = { enable = true; };
      illuminate = { enable = true; };
      todo-comments = { enable = true; };
      gitsigns = { enable = true; };
      lsp-lines = { enable = true; };
      lsp-format = { enable = true; };
      helm = { enable = true; };
      lsp = {
        enable = true;
	# TODO: fix the lsp package options somehow
/*        servers = {
          # bashls.enable = true;
          clangd.enable = true;
          csharp-ls.enable = true;
          dockerls.enable = true;
          java-language-server.enable = true;
          jsonls.enable = true;
          html.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          pyright.enable = true;
          rust-analyzer = { 
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          sqls.enable = true;
          yamlls.enable = true;
        };
      };
      luasnip = { enable = true; };
      telescope = {
        enable = true;
        extensions.file-browser.enable = true;
      };
      which-key.enable = true;
      markdown-preview = {
        enable = true;
        settings.browser = "firefox";
        theme = "dark";
      };
    };  
  };
 */
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
/*
  # games gaming section
  programs.steam = {
    enable = true;
  };
 
  environment.systemPackages = with pkgs; [
    wineWoWPackages.stable
    wine
    wineWowPackages.staging
    winetricks
    wineWowPackages.waylandFull
    lutris
  ];
 
  environment.systemPackages = [
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
	obs-backgroundremoval
	obs-pipewire-audio-capture
      ];
    })
  ];
*/
  # List packages installed in system profile. To search, run:
  # $ nix search wget
 
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
   networking.firewall.enable = true;
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
 
}
