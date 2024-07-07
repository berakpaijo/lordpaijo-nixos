# flake.nix, NixOS configuration with Flakes
{
  description = "My NixOS configuration with Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # follow unstable channel
    home-manager.url = "github:nix-community/home-manager/master"; # Home Manager channel
    stylix.url = "github:danth/stylix";
  };	

  outputs = { self, nixpkgs, home-manager, stylix, ... } @ inputs: let
    inherit (self) outputs; # to export the output variable
    system = "x86_64-linux"; # your system
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
      nixosConfigurations = {
        # Your Computer name (hostname)
        nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs; # so you can access inputs outputs in your configuration.nix, etc
        };
        modules = [
          ./configuration.nix
          inputs.stylix.nixosModules.stylix
        ];
      };
      # Home manager
      home-manager.nixosModules.home-manager =
      {
        nix.registry.nixos.flake = inputs.self;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        imports = [
          ./home/lordpaijo/.config/home-manager/home.nix # your home-manager config
        ];
      };
    };
  };
    #genericModules = [
    #./configuration.nix
    #];
    #{
    # Fix for nixpkgs without flakes
      #nix.registry.nixos.flake = inputs.self;
      #environment.etc."nix/inputs/nixpkgs".source = nixpkgs.outPath;
      #nix.nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
    #}

}
