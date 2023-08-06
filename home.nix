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
}
