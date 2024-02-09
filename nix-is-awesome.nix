{ lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  fmt,
  qrencode,
  wasilibc ? if stdenv.targetPlatform.isWasm then wasilibc else null
}:
stdenv.mkDerivation rec{
  pname = builtins.trace (if stdenv.targetPlatform.isWasm then "yes" else "no") "nix-is-awesome";
  version = "0.1.0";

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [
    fmt
    qrencode.dev
    qrencode.out
  ] ++ lib.optional (stdenv.targetPlatform.isWasm) [ wasilibc ];

  src = ./.;


  ninjaFlags = [ "-v" ];
  # cmakeFlags = [];

}
