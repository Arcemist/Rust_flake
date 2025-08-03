{
  description = "A Rust Development Enviroment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
    in {
      devShells.default = with pkgs; mkShell {
        buildInputs = [
	  rust-bin.stable.latest.default
	];

        # For convinience
	# Need fish in normal user enviroment
	# The "exec" makes it so it does not need to be closed 2 times
	shellHook = ''
          exec fish
	'';
      };

      # nix develop .#nombre
      # Makes a dev enviroment that includes what you put here,
      # in addition to what is in the default option.
      #devShells.nombre = pkgs.mkShell {
      #  buildInputs = [
      #    pkgs.lsd
      #  ];
      #};
    }
  );
}
