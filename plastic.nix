{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  alsa-lib,
  wayland,
  libxkbcommon,
  libGL,
  patchelf,
  autoPatchelfHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "plastic";
  version = "unstable-2024-10-22"; # Using today's date since we're pulling from main

  src = fetchFromGitHub {
    owner = "Amjad50";
    repo = "plastic";
    # Since we don't have a specific commit hash, you'll want to replace these with
    # the actual values from `nix-prefetch-git https://github.com/Amjad50/plastic`
    rev = "292ae8415ce5f479b6096c54cc3197731ce73e2e";
    hash = "sha256-oy48ptf4HLe162Q4heW47T4w9+SP8sZ0ygv4ulXjT+g=";
  };

  nativeBuildInputs = [patchelf pkg-config autoPatchelfHook];
  buildInputs = [alsa-lib wayland.out libxkbcommon libGL stdenv.cc.cc.lib];
  postInstall = ''
    patchelf --add-needed libwayland-client.so \
      --add-needed libwayland-egl.so \
      --add-needed libwayland-server.so \
      --add-needed libxkbcommon.so.0.0.0 \
      --add-needed libEGL.so \
      --add-needed libGL.so \
      $out/bin/plastic
  '';
  doCheck = false;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  meta = with lib; {
    description = "A Game Boy (DMG) emulator written in Rust";
    homepage = "https://github.com/Amjad50/plastic";
    license = licenses.mit;
    mainProgram = "plastic";
    platforms = platforms.all;
  };
}
