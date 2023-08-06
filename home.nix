{ config, pkgs, lib, ...}:

{
  home.username = "yishern";
  home.homeDirectory = "/Users/yishern";

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

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
      go = "git checkout";
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
      # if not set -q TMUX
      #   tmux attach -t TMUX || tmux new -s TMUX
      # end
      # >>> conda initialize >>> 
      if test -f /Users/yishern/miniconda3/bin/conda
        eval /Users/yishern/miniconda3/bin/conda "shell.fish" "hook" $argv | source
      end
      # <<< conda initialize <<<
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
