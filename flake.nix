{
  description = "nix is awesome";

  inputs.nixpkgs.url = "github:nixOS/nixpkgs/5a09cb4b393d58f9ed0d9ca1555016a8543c2ac8";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Create a package set based on the build system
        pkgs = import nixpkgs { inherit system; };

        pkgsr = import nixpkgs { inherit system;
                                 crossSystem = nixpkgs.lib.systems.examples.riscv64; };
        pkgsw = import nixpkgs { inherit system;
                                 crossSystem = nixpkgs.lib.systems.examples.mingwW64;
                               };
        pkgsa = import nixpkgs { inherit system;
                                 crossSystem = nixpkgs.lib.systems.examples.aarch64-android-prebuilt;
                               };

        buildTools = pkgs: [ pkgs.cmake pkgs.ninja pkgs.fish pkgs.pkg-config ];
        deps = pkgs: [ pkgs.fmt pkgs.qrencode.dev pkgs.qrencode.out ];

        builder = pkgs: pkgs.callPackage ./nix-is-awesome.nix {};

        clangStdenv = pkgs.overrideCC pkgs.stdenv pkgs.llvmPackages.clangUseLLVM;
      in {

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = buildTools pkgs;
          buildInputs = deps pkgs;
          shellHook =
            ''
            fish && exit
            '';
        };

        devShells.clang = (pkgs.mkShell.override { stdenv =  clangStdenv;}) {
          nativeBuildInputs = buildTools pkgs;
          buildInputs = deps pkgs;
          shellHook =
            ''
              fish && exit
            '';
        };

        packages.nia = builder pkgs;
        packages.nia_clang = (builder pkgs).override { stdenv = clangStdenv; };
        packages.nia_riscv = builder pkgsr;
        packages.nia_win = builder pkgsw;
        packages.nia_android = builder pkgsa;
      }
    );
}
