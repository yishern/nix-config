{ config, pkgs, lib, ...}:

{
  home.username = "yishern";
  home.homeDirectory = "/Users/yishern";

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
