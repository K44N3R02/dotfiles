{
  # To update: $ nix flake update
  description = "K44N's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.anki-bin
          pkgs.brave
          pkgs.cargo
          pkgs.fzf
          # pkgs.kanata
          pkgs.kitty
          pkgs.libreoffice-bin
          pkgs.mkalias
          pkgs.neovim
          pkgs.obsidian
          pkgs.python313
          pkgs.rectangle
          pkgs.ripgrep
          pkgs.rustc
          pkgs.sc-im
          pkgs.tmux
          pkgs.zig
          pkgs.zotero
        ];

      homebrew = {
        enable = true;
        brews = [
          "mas"
          # "pearcleaner"
          # "kanata"
        ];
        taps = [ ];
        casks = [
          "hammerspoon"
          "iina"
          "karabiner-elements"
          "vscodium"
          "the-unarchiver"
        ];
        masApps = {
          "Stockfish Chess" = 801463932;
          "Whatsapp" = 310633997;
          "Bitwarden" = 1352778147;
          "XCode" = 497799835;
          # "VIA" = 1439900554;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
          "${pkgs.kitty}/Applications/Kitty.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "${pkgs.brave}/Applications/Brave Browser.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Reminders.app"
        ];
        finder.FXPreferredViewStyle = "clmv";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      # NOTE:
      # error:
      # Failed assertions:
      # - The option definition `services.nix-daemon.enable' in `<unknown-file>' no longer has any effect; please remove it.
      # nix-darwin now manages nix-daemon unconditionally when
      # `nix.enable` is on.

      # services.nix-daemon.enable = true;
      # # Auto upgrade nix package and the daemon service.

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."k44n-m4" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            # Apple Silicon only
            enableRosetta = true;
            # User owning the homebrew prefix
            user = "k44n";
          };
        }
      ];
    };
    darwinPackages = self.darwinConfigurations."k44n-m4".pkgs;
  };
}
