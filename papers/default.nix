{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.stdenv.mkDerivation({
  name = "diff-mono-repo-poly-repo";
  src = ./.;

  buildInputs = with pkgs; [ 
    (texlive.combine {
      inherit (texlive)
        scheme-small
        amsmath
        zref
        amsfonts
        stmaryrd
        algorithm2e
        mdframed
        listings
        ifoddpage
        relsize
        needspace
        xcharter
        ly1
        cyrillic
        geometry;
    })
  ];

  FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = [ pkgs.lmodern ]; };

  buildPhase = ''
    # See: https://tex.stackexchange.com/questions/496275/texlive-2019-lualatex-doesnt-compile-document
    # Without export, lualatex fails silently, with exit code '0'
    export TEXMFVAR=$(pwd)
    export CURRENT_DATE=$(date +'%A, %d %B %Y')
    lualatex -interaction=nonstopmode structuring-project-for-k8s.tex
  '';

  installPhase = ''
    mkdir -p $out
    cp structuring-project-for-k8s.log $out
    cp structuring-project-for-k8s.pdf $out
  '';
})
