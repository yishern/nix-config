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
}
