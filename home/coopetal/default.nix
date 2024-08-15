
{ config, pkgs, lib, ... }:

{
  imports = [
    # Core configuration
    # common/core  # TODO: add core module
  ];
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

    alacritty
    bat
    eza
    fd
    # git-crypt
    gnumake  # LunarVim dependency
    # gnupg
    just
    lunarvim
    neofetch
    nodejs_22  # LunarVim dependency
    python312
    python312Packages.pip
    ripgrep
    rustup  # LunarVim dependency
    unzip  # LunarVim dependency
    
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

    # ".config/nvim" = {
    #   source = ./nvim;
    #   recursive = true;
    # };
  };

  # TODO: Neovim
  # xdg.configFile = {
  #   "nvim" = {
  #     source = ./nvim;
  #     recursive = true;
  #   };
  # };

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
    EDITOR = "lvim";  # Set default editor
  };

  # home.file = {
    # ".config/nvim".source = fetchFromGitHub {
    #    owner = "coopetal";
    #    repo = "nvim";
    #    rev = "1860184";
    #    sha256 = "1xfax18y4ddafzmwqp8qfs6k34nh163bwjxb7llvls5hxr79vr9s";
    #    leaveDotGit = true;
    # };
  # }

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    carapace.enable = true;

    git = {
      enable = true;
      userName  = "coopetal";
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

    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   withNodeJs = true;
    #   withPython3 = true;
    #   withRuby = true;
    #   extraConfig = ''
    #     set number relativenumber
    #     '';
    #   # extraLuaConfig = ''
    #   #   require('lazy').setup({
    #   #     {
    #   #       "nvim-treesitter/nvim-treesitter",
    #   #       config = function(_, opts)
    #   #         opts.auto_install = false
    #   #         opts.ensure_installed = {}
    #   #         return opts
    #   #       end,
    #   #     },
    #   #   }
    #   # '';
    #   # extraPackages = with pkgs; [
    #     # Formatters
    #     # gofumpt
    #     # goimports-reviser
    #     # golines

    #     # # LSP
    #     # gopls

    #     # Tools
    #     # go
    #     # gcc
    #   # ];
    #   plugins = with pkgs.vimPlugins; [
    #   #   # Languages

    #   #   # Formatters

    #   #   # LSP

    #   #   # Treesitter
    #     nvim-treesitter.withAllGrammars
    #   #   Tagbar
    #   #   treesj

    #   #   # Git
    #   #   git-blame-nvim
    #   #   gitignore-nvim

    #   #   # Tools
    #   #   chadtree
    #   #   indent-blankline-nvim
    #   #   telescope-nvim
    #   #   toggleterm-nvim
	   #  #   vim-sleuth
    #   #   which-key-nvim

    #   #   # Motions
    #   #   leap-nvim
    #   #   nvim-surround
    #   ];
    #   # List of plugins to add:
    #   # vimtex  # LaTeX
    #   # leap-spooky.nvim
    #   # speeddating.vim


    # };

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

    starship = { enable = true;
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
