{ stdenv, config, lib, pkgs, ... }:

with pkgs;
stdenv.mkDerivation rec {
  name = "parsec-unstable";
  src = ./parsec-linux.deb;

  # wget https://builds.parsecgaming.com/package/parsec-linux.deb

  # Todo: set up wrapper to fix this:
  #  mkdir -p ~/.parsec/ && cp -vn usr/share/parsec/skel/* ~/.parsec/

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    libGL stdenv.cc.cc.lib openssl
  ];

  dontUnpack = true;
   installPhase = ''
    runHook preInstall

    dpkg-deb -x $src $out
    mv $out/usr/* $out
    rmdir $out/usr
    chmod 755 $out
    runHook postInstall
  '';


   # Todo: make this nicer
   postFixup = ''
     wrapProgram $out/bin/parsecd \
       --prefix LD_PRELOAD : ${lib.makeLibraryPath [xorg.libXcursor]}/libXcursor.so.1 \
       --prefix LD_PRELOAD : ${lib.makeLibraryPath [xorg.libXi]}/libXi.so.6 \
       --prefix LD_PRELOAD : ${lib.makeLibraryPath [openssl]}/libcrypto.so.1.1 \
       --prefix LD_PRELOAD : ${lib.makeLibraryPath [openssl]}/libssl.so.1.1 \
       --prefix LD_PRELOAD : ${lib.makeLibraryPath [stdenv.cc.cc.lib]}/libstdc++.so.6 \
       --prefix LD_PRELOAD : ${lib.makeLibraryPath [systemd]}/libudev.so.1 \
       --prefix LD_PRELOAD : ${lib.makeLibraryPath [alsa-lib]}/libasound.so \
       --prefix LD_PRELOAD : ${lib.makeLibraryPath [libGL]}/libGL.so.1
   '';

}
