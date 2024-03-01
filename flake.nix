{
  description = "Home Manager configuration of yishern";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, home-manager, ...}:
    let
      system = "aarch64-darwin";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs { system = "aarch64-darwin"; config = { permittedInsecurePackages = [ "ruby-2.7.8" "openssl-1.1.1w" ]; }; };
    in {
      homeConfigurations."yishern" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	modules = [ ./home.nix ];
      };
    };
}
