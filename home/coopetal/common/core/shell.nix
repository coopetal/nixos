{ inputs, outputs, config, lib, ... }:

{
  programs = {
    # Autocomplete plugin for zsh and nushell
    carapace.enable = true;

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

    # Starship prompt tweaked and adapted for nix format from 1amSimp1e by Nhan: https://github.com/1amSimp1e/dots/blob/main/configs/prompt/starship.toml
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$hostname"
          "$directory"

          "$localip"
          "$shlvl"
          "$singularity"
          "$kubernetes"
          "$vcsh"
          "$hg_branch"
          "$docker_context"
          "$package"
          "$custom"

          "$sudo"

          "$fill"
          "$git_branch"
          "$git_status"
          "$git_commit"
          "$cmd_duration"
          "$jobs"
          "$battery"
          "$time"
          "$status"
          "$os"
          "$container"
          "$shell"
          "$line_break"
          "$character"
        ];
        hostname = {
          ssh_only = true;
          format = "[](fg:#8BC6FC bg:none)[  ](bold fg:#252525 bg:#8BC6FC)[ ](fg:#8BC6FC bg:#E8E3E3)[$hostname](bold fg:#303030 bg:#E8E3E3)[](fg:#E8E3E3 bg:none) ";
          disabled = false;
        };
        directory = {
          format = "[](fg:#252525 bg:none)[$path]($style)[█](fg:#232526 bg:#232526)[](fg:#6791C9 bg:#252525)[  ](fg:#252525 bg:#6791C9)[](fg:#6791C9 bg:none)";
          style = "fg:#E8E3E3 bg:#252525 bold";
          truncation_length = 3;
          truncate_to_repo=false;
          read_only = " ";
        };
        character = {
          success_symbol = "[ ](#6791C9 bold)";
          error_symbol = "[ ](#B66467 bold)";
        };
        line_break.disabled = false;
        fill = {
          symbol = " ";
          style = "bold green";
        };
        cmd_duration = {
          min_time = 1;
          format = "[](fg:#252525 bg:none)[$duration]($style)[](fg:#252525 bg:#252525)[](fg:#C397D8 bg:#252525)[ 󱎫 ](fg:#252525 bg:#C397D8)[](fg:#C397D8 bg:none)";
          disabled = false;
          style = "fg:#E8E3E3 bg:#252525 bold";
        };
        git_branch = {
          format = "[](fg:#252525 bg:none)[$branch]($style)[](fg:#252525 bg:#252525)[](fg:#81C19B bg:#252525)[  ](fg:#252525 bg:#81C19B)[](fg:#81C19B bg:none) ";
          style = "fg:#E8E3E3 bg:#252525";
          symbol = " ";
        };
        git_status = {
          format="[](fg:#252525 bg:none)[$all_status$ahead_behind]($style)[](fg:#252525 bg:#252525)[](fg:#FFB347 bg:#252525)[  ](fg:#252525 bg:#FFB347)[](fg:#FFB347 bg:none) ";
          style = "fg:#E8E3E3 bg:#252525";
          conflicted = "=";
          ahead =	"⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          up_to_date = " 󰄸";
          untracked = "?\${count}";
          stashed = "";
          modified = "!\${count}";
          staged = "+\${count}";
          renamed = "»\${count}";
          deleted = " \${count}";
        };
        git_commit = {
          format = "[\\\\($hash\\\\)]($style) [\\\\($tag\\\\)]($style)";
          style = "green";
        };
        git_state = {
          rebase = "REBASING";
          merge =	"MERGING";
          revert = "REVERTING";
          cherry_pick = "CHERRY-PICKING";
          bisect = "BISECTING";
          am = "AM";
          am_or_rebase = "AM/REBASE";
          style =	"yellow";
          format = "\\([$state( $progress_current/$progress_total)]($style)\) ";
        };

        ## SYMBOLS
        aws.symbol = "  ";
        conda.symbol = " ";
        dart.symbol = " ";
        docker_context = {
          symbol = " ";
          format = "via [$symbol$context]($style) ";
          style = "blue bold";
          only_with_files = true;
          detect_files = ["docker-compose.yml" "docker-compose.yaml" "Dockerfile"];
          detect_folders = [];
          disabled = false;
        };
        elixir.symbol = " ";
        elm.symbol = " ";
        golang.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        haskell.symbol = "λ ";
        memory_usage.symbol = " ";
        nim.symbol = " ";
        nix_shell.symbol = " ";
        package.symbol = " ";
        perl.symbol = " ";
        php.symbol = " ";
        python = {
          symbol = " ";
          #pyenv_version_name = true;
          format = "via [\${symbol}python (\${version} )(\($virtualenv\) )]($style)";
          style = "bold yellow";
          pyenv_prefix = "venv ";
          python_binary = ["./venv/bin/python" "python" "python3" "python2"];
          detect_extensions = ["py"];
          version_format = "v\${raw}";
        };
        ruby.symbol = " ";
        rust.symbol = " ";
        scala.symbol = " ";
        shlvl.symbol = " ";
        swift.symbol = "ﯣ ";
        nodejs = {
          format = "via [ Node.js $version](bold green) ";
          detect_files = ["package.json" ".node-version"];
          detect_folders = ["node_modules"];
        };
        # Other languages configurations:
        c.disabled = true;
        cmake.disabled = true;
        haskell.disabled = true;
        python.disabled = true;
        ruby.disabled = true;
        rust.disabled = true;
        perl.disabled = true;
        package.disabled = true;
        lua.disabled = true;
        nodejs.disabled = true;
        java.disabled = true;
        golang.disabled = true;
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = "${config.xdg.configHome}/zsh";

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
