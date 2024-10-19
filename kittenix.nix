{
  neovim,
  vimPlugins,
  git,
  gh,
  bash,
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  direnv,
  vimUtils,
  makeWrapper
} @ args:

let
 
  project_name = "kittenix";
  project_ver = "0.0.1b03.3";
  buildInputs = [
   neovim
   vimPlugins.lazy-nvim
   git
   gh
   bash
   direnv
  ];
  install_dir = "~/.cache/kittenvim";


  buildPhase = ''
   runHook preInstall
   KITTENVIM_DIR="~/.cache/kittenvim"
   runHook postInstall
  '';

  shellHook = ''
    $SHELL $KITTENVIM_DIR/uppies.sh $KITTENVIM_DIR
  '';

in

stdenv.mkDerivation {
 
 pname = project_name;
 version = project_ver;
 src = fetchFromGitHub {
    owner = "octakitten";
    repo = "kittenvim";
    rev = "v0.0.1b03";
    name = project_name;
    sha256 = "CADgI9g17gMkw8VhI0LSLYg10U3XyyX3vKGnJStW9o8=";
  };


}
