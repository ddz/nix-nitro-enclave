let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  packages = with pkgs; [
    emacs
    emacsPackages.magit
    emacsPackages.go-mode
    emacsPackages.nix-mode
    emacsPackages.markdown-mode
    git
    gh
    gnumake
    nixfmt-rfc-style
    vim
  ];
}
