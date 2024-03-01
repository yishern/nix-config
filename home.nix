{ config, pkgs, lib, ...}:

{
  home.username = "yishern";
  home.homeDirectory = "/Users/yishern";

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    gnumake

    # Go programmming
    # go
    ripgrep
    nodejs_20
    awscli2
    
    # Ruby
    (
      ruby_2_7.overrideDerivation (oldAttrs: {

        version = "2.7.6";
        src = pkgs.fetchurl {
          # url = "https://github.com/ruby/ruby/archive/refs/tags/v2_7_6.tar.gz";
          url = "https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.6.tar.gz";
          sha256 = "sha256-5yA7DMCUQu0sCJNtSD+KwUDsHHLje7XEAWRreGbLXRA=";
          # sha256 = "sha256-rqC9s9+Ad4FmMM63JVf8nUqxufg1vQCNvclmLp/7sMU=";
        };
      })
    )
  ];

  home.sessionVariables = {
    SHELL = "${lib.getBin pkgs.fish}/bin/fish";
  };

  fonts.fontconfig.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
  };
  xdg.configFile."nvim/init.lua".source = ./config/nvim/init.lua;

  programs.git = {
    enable = true;
    userName = "yishern";
    userEmail = "44721502+yishern@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    escapeTime = 1;
    historyLimit = 10000;
    clock24 = true;
    keyMode = "vi";
    aggressiveResize = true;
  };

  home.file = {
    tmux = {
      source = ./config/tmux/tmux.conf;
      target = ".tmux.conf";
      recursive = true;
    };
    tmuxlocal = {
      source = ./config/tmux/tmux.conf.local;
      target = ".tmux.conf.local";
      recursive = true;
    };
  };

  programs.fish = {
    enable = true;
    plugins = [
      # Need this to source ~/.nix-profile/bin when using fish as default macOS shell
      {
        name = "nix-env.fish";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
   ];

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      # List files with -F decorative endings.
      ls = "ls -F"; 
      # List files with -F decorative endings, including hidden files.
      lsa = "ls -Fa"; 
      # List files long, with human-readable sizes.
      lsl = "ls -hlF";
      # List files long, with human-readable sizes, including hidden files.
      lsla = "ls -halF";
    };
    
    shellAbbrs = {
      g = "git";
      gs = "git status";
      ga = "git add";
      gb = "git branch";
      gco = "git checkout";
      gc = "git commit";
      gcm = "git commit -m";
      gcamend = "git commit --amend";
      gd = "git diff";
      gr = "git rebase";
      grc = "git rebase --continue";
      gra = "git rebase --abort";
    };

    functions = {
      cs = {
        # https://github.com/fish-shell/fish-shell/issues/583
        description = "Automatically list directory contents when navigating";
        onVariable = "PWD";
        body = "ls";
      };
      bind_bang = {
        # https://superuser.com/questions/719531/what-is-the-equivalent-of-bashs-and-in-the-fish-shell
        description = "Bring back !! from bash";
        body = ''
          switch (commandline -t)[-1]
            case "!"
              commandline -t $history[1]; commandline -f repaint
            case "*"
              commandline -i !
          end
        '';
      };
    };

    interactiveShellInit = ''
      # Explicitly source the event listener. https://github.com/fish-shell/fish-shell/issues/845
      cs
      # Add a line to my prompt?
      # https://github.com/pure-fish/pure/blob/master/conf.d/_pure_init.fish
      functions --query _pure_prompt_new_line
      function fish_user_key_bindings
        bind ! bind_bang
      end
      export PATH="$HOME/.local/bin:$PATH"

      # uv for Python
      export PATH="$HOME/.cargo/bin:$PATH"

      eval /Users/yishern/miniconda3/bin/conda "shell.fish" "hook" $argv | source
      # if not set -q TMUX
      #   tmux attach -t TMUX || tmux new -s TMUX
      # end
    '';
  };

  programs.alacritty = {
    enable=true;
    package =pkgs.alacritty;
    settings = {
      live_config_reload = true;

      shell = {
        program = "${lib.getBin pkgs.fish}/bin/fish";
      };

      # Window.
      dynamic_title = true;
      window.padding = {
        x = 0;
        y = 0;
      };
      window.decorations = "buttonless";

      font = {
        size = 13.0;
        offset.y = 2;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
      };

      #Colors.
      # colors = {
      #   primary = {
      #     background = "0x1c1f22";
      #     foreground = "0xd1d8e0";
      #   };

      #   cursor = {
      #     text = "0xd1d8e0";
      #     cursor = "0xf9f9f3";
      #     style = "Block";
      #   };

      #   normal = {
      #     black   = "0x2d3135";
      #     red     = "0xc8233b";
      #     green   = "0xbfd269";
      #     yellow  = "0xf48a81";
      #     blue    = "0xffc850";
      #     magenta = "0x4ac0cf";
      #     cyan    = "0xfb8562";
      #     white   = "0xdde3e8";
      #   };

      #   bright = {
      #     black   = "0x494f54";
      #     red     = "0xed3855";
      #     green   = "0xdde7b3";
      #     yellow  = "0xfbd7d4";
      #     blue    = "0xffe5b4";
      #     magenta = "0x9cdae3";
      #     cyan    = "0xfdccbf";
      #     white   = "0xf7f7f9";
      #   };
      # };

      # Catppuccin (Macchiato) theme
      colors = {
        primary = {
          background = "#24273A";
          foreground = "#CAD3F5";
          dim_foreground = "#CAD3F5";
          bright_foreground = "#CAD3F5";
        };
        cursor = {
          text = "#24273A";
          cursor = "#F4DBD6";
        };
        vi_mode_cursor = {
          text = "#24273A";
          cursor = "#B7BDF8";
        };
        search_matches = {
          foreground = "#24273A";
          background = "#A5ADCB";
        };
        search_focused_match = {
          foreground = "#24273A";
          background = "#A6DA95";
        };
        footer_bar = {
          foreground = "#24273A";
          background = "#A5ADCB";
        };
        hints_start = {
          foreground = "#24273A";
          background = "#EED49F";
        };
        hints_end = {
          foreground = "#24273A";
          background = "#A5ADCB";
        };
        selection = {
          text = "#24273A";
          background = "#F4DBD6";
        };
        normal = {
          black = "#494D64";
          red = "#ED8796";
          green = "#A6DA95";
          yellow = "#EED49F";
          blue = "#8AADF4";
          magenta = "#F5BDE6";
          cyan = "#8BD5CA";
          white = "#B8C0E0";
        };
        bright = {
          black = "#5B6078";
          red = "#ED8796";
          green = "#A6DA95";
          yellow = "#EED49F";
          blue = "#8AADF4";
          magenta = "#F5BDE6";
          cyan = "#8BD5CA";
          white = "#A5ADCB";
        };
        dim = {
          black = "#494D64";
          red = "#ED8796";
          green = "#A6DA95";
          yellow = "#EED49F";
          blue = "#8AADF4";
          magenta = "#F5BDE6";
          cyan = "#8BD5CA";
          white = "#B8C0E0";
        };
        indexed_colors = [
          {index = 16; color = "#F5A97F";}
          {index = 17; color = "#F4DBD6";}
        ];
      };
      # Nord theme

      # colors = {
      #   primary = {
      #     background =  "#2e3440";
      #     foreground =  "#d8dee9";
      #     dim_foreground = "#a5abb6";
      #   };
      #   cursor = {
      #     text =  "#2e3440";
      #     cursor = "#d8dee9";
      #   };
      #   vi_mode_cursor = {
      #     text = "#2e3440";
      #     cursor = "#d8dee9";
      #   };
      #   selection = {
      #     text = "CellForeground";
      #     background = "#4c566a";
      #   };
      #   search = {
      #     matches = {
      #       foreground = "CellBackground";
      #       background = "#88c0d0";
      #     };
      #     footer_bar = {
      #       background = "#434c5e";
      #       foreground = "#d8dee9";
      #     };
      #   };
      #   normal = {
      #     black = "#3b4252";
      #     red = "#bf616a";
      #     green = "#a3be8c";
      #     yellow = "#ebcb8b";
      #     blue = "#81a1c1";
      #     magenta = "#b48ead";
      #     cyan = "#88c0d0";
      #     white = "#e5e9f0";
      #   };
      #   bright = {
      #     black = "#4c566a";
      #     red = "#bf616a";
      #     green = "#a3be8c";
      #     yellow = "#ebcb8b";
      #     blue = "#81a1c1";
      #     magenta = "#b48ead";
      #     cyan = "#8fbcbb";
      #     white = "#eceff4";
      #   };
      #   dim = {
      #     black = "#373e4d";
      #     red = "#94545d";
      #     green = "#809575";
      #     yellow = "#b29e75";
      #     blue = "#68809a";
      #     magenta = "#8c738c";
      #     cyan = "#6d96a5";
      #     white = "#aeb3bb";
      #   };
      # };

      draw_bold_text_with_bright_colors = true;
      key_bindings = let tmux = "${lib.getBin pkgs.tmux}/bin/tmux"; in [
        # Alt+Left and Right to skip words.
        { key = "Right"; mods = "Alt"; chars = "\\x1bf"; }
        { key = "Left";  mods = "Alt"; chars = "\\x1bb"; }

        # tmux
        { key = "LBracket"; mods = "Command|Shift"; 
          command = { program = tmux; args = ["previous-window"]; }; 
        }
        { key = "RBracket"; mods = "Command|Shift";
          command = { program = tmux; args = ["next-window"]; }; 
        }
        { key = "LBracket"; mods = "Command"; 
          command = { program = tmux; args = ["select-pane" "-L"]; }; 
        }
        { key = "RBracket"; mods = "Command";
          command = { program = tmux; args = ["select-pane" "-R"]; }; 
        }
        { key = "T"; mods = "Command";
          command = { program = tmux; args = ["new-window"]; }; 
        }
        { key = "Return"; mods = "Command|Shift";
          command = { program = tmux; args = ["resize-pane" "-Z"]; }; 
        }
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
