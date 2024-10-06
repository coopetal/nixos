{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Core configuration
    common/core
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      inputs.neovim.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "coopetal";
  home.homeDirectory = "/home/coopetal";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    bat
    eza
    fd
    fzf
    # git-crypt
    gnumake # LunarVim dependency
    # gnupg
    just
    lunarvim
    neofetch
    nodejs_22 # LunarVim dependency
    nvim-pkg # Personal Neovim configuration using Kickstart-nix.nvim flake template
    python312
    python312Packages.pip
    qbittorrent
    ripgrep
    rustup # LunarVim dependency
    unzip # LunarVim dependency

    # Fonts
    # jetbrains-mono
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/chech/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "lvim"; # Set default editor
  };

  # dconf.settings = {
  #   "/org/gnome/settings-daemon/plugins/media-keys" = {
  #     home = "<Super>f";
  #     calculator = "<Super>c";
  #     www = "<Super>b";
  #   };
  #   "/org/gnome/desktop/wm/keybindings" = {
  #     switch-to-workspace-left = "<Super>q";
  #     switch-to-workspace-right = "<Super>w";
  #     close = "<Super>x";
  #   };
  #   "/org/gnome/shell/keybindings" = {
  #     toggle-overview = "<Super>d";
  #   };
  #   "/org/gnome/settings-daemon/plugins/media-keys" = {
  #     custom-keybindings = [
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #     ];
  #   };
  #   "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #     binding = "<Super>t";
  #     command = "alacritty";
  #     name = "Launch terminal";
  #   };
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    alacritty = {
      enable = true;
      settings = {
        # Auy Dark theme
        colors.primary = {
          background = "#0A0E14";
          foreground = "#B3B1AD";
        };
        colors.normal = {
          black = "#01060E";
          red = "#EA6C73";
          green = "#91B362";
          yellow = "#F9AF4F";
          blue = "#53BDFA";
          magenta = "#FAE994";
          cyan = "#90E1C6";
          white = "#C7C7C7";
        };
        colors.bright = {
          black = "#686868";
          red = "#F07178";
          green = "#C2D94C";
          yellow = "#FFB454";
          blue = "#59C2FF";
          magenta = "#FFEE99";
          cyan = "#95E6CB";
          white = "#FFFFFF";
        };

        # Options
        font.normal = {
          family = "MesloLGS Nerd Font";
        };
        keyboard.bindings = [
          {
            action = "CreateNewWindow";
            key = "T";
            mods = "Control | Shift";
          }
        ];
        window = {
          decorations = "none";
          opacity = 0.95;
          title = "Alacritty";
          decorations_theme_variant = "dark";
        };
        window.class = {
          general = "Alacritty";
          instance = "Alacritty";
        };
        window.padding = {
          x = 8;
          y = 8;
        };
      };
    };

    carapace.enable = true;

    git = {
      enable = true;
      userName = "coopetal";
      userEmail = "coopetal@proton.me";

      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        url = {
          "https://github.com/" = {
            insteadOf = [
              "gh:"
              "github:"
            ];
          };
        };
      };
    };

    # nushell = {
    #   enable = true;
    #   # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
    #   configFile.source = ./nushell/config.nu;
    #   # for editing directly to config.nu
    #   extraConfig = ''
    #     let carapace_completer = {|spans|
    #       carapace $spans.0 nushell $spans | from json
    #     }
    #     $env.config = {
    #       show_banner: false,
    #       completions: {
    #         case_sensitive: false # case-sensitive completions
    #         quick: true    # set to false to prevent auto-selecting completions
    #         partial: true    # set to false to prevent partial filling of the prompt
    #         algorithm: "fuzzy"    # prefix or fuzzy
    #         external: {
    #           # set to false to prevent nushell looking into $env.PATH to find more suggestions
    #           enable: true
    #           # set to lower can improve completion performance at the cost of omitting some options
    #           max_results: 100
    #           completer: $carapace_completer # check 'carapace_completer'
    #         }
    #       }
    #     }
    #     $env.PATH = ($env.PATH |
    #       split row (char esep) |
    #       prepend /home/myuser/.apps |
    #       append /usr/bin/env
    #     )
    #   '';
    #   # shellAliases = {
    #     # vi = "hx";
    #     # vim = "hx";
    #     # nano = "hx";
    #   # };
    # };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = "./zsh";

      shellAliases = {
        cat = "bat";
        ls = "eza";
        ll = "eza -lah";
        update = "sudo nixos-rebuild switch";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };
  };
}
