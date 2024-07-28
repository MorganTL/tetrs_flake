{
  description = "tetrs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ (import rust-overlay) ];
      };

      rust = pkgs.rust-bin.stable."1.80.0".default.override {
        extensions = [ "rust-src" ];
        targets = [ ];
      };
      rustPlatform = pkgs.makeRustPlatform {
        rustc = rust;
        cargo = rust;
      };

      tetrs = rustPlatform.buildRustPackage {
        version = "0.1.0";
        pname = "tetrs_terminal";
        src = pkgs.fetchFromGitHub {
          owner = "Strophox";
          repo = "tetrs";
          rev = "93dc5f6700d32c6d948428a4f6d86c97e33a9764";
          hash = "sha256-lv39ftC6RuYdbMHsiZPMST9Ewtl7lwHl0qAn8VqmoWk=";
        };

        cargoHash = "sha256-qCf646DGOEJ8xMxxUaBB1L8pEUalsHy5YznYWODqpiY= ";

        cargoPatches = [
          # a patch file to add/update Cargo.lock in the source code
          ./add-cargo-lock.patch
        ];
      };
    in
    {
      packages.x86_64-linux.default = tetrs;
    };
}
