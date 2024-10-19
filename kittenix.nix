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
 
  project_name = "kittenvim";
  project_ver = "0.0.1b05";
  buildInputs = [
   neovim
   vimPlugins.lazy-nvim
   git
   gh
   bash
   direnv
  ];
  install_dir = "$HOME/.config/kittenvim";

  buildPhase = ''
   runHook preInstall
   make clean
   make
   runHook postInstall
  '';

  shellHook = ''
    $SHELL ${install_dir}/uppies.sh
  '';

in

stdenv.mkDerivation {
 
 pname = project_name;
 version = project_ver;
 src = fetchFromGitHub {
    owner = "octakitten";
    repo = "kittenvim";
    rev = "v0.0.1b04";
    name = project_name;
    sha256 = "CADgI9g17gMkw8VhI0LSLYg10U3XyyX3vKGnJStW9o8=";
  };


}
