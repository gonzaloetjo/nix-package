{ inputs, pkgs, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable { system = pkgs.system; };
in {
    # https://devenv.sh/basics/
    env.GREET = "This is a TDP nix environment";

    # https://devenv.sh/packages/
    packages = [ 
      pkgs.git
      pkgs.jq
      pkgs.ansible
      pkgs.zip
      pkgs.unzip
      pkgs.libkrb5
      pkgs-stable.python39
      pkgs-stable.python39Packages.pip
      pkgs-stable.python39Packages.virtualenv
      pkgs-stable.python39Packages.venvShellHook
      pkgs-stable.nodejs
    ];

    enterShell = ''
      echo -e "\\033[1;34m*********************************************************\\033[0m"
      echo -e "\\033[1;34m*                                                       *\\033[0m"
      echo -e "\\033[1;34m*    \\033[1;32mWelcome to the Nix package environment for TDP!\\033[1;34m    *\\033[0m"
      echo -e "\\033[1;34m*                                                       *\\033[0m"
      echo -e "\\033[1;34m*    For more information, please visit:                *\\033[0m"
      echo -e "\\033[1;36m*    https://github.com/TOSIT-IO/tdp-getting-started/   *\\033[0m"
      echo -e "\\033[1;34 m*                                                       *\\033[0m"
      echo -e "\\033[1;34m*********************************************************\\033[0m"
    '';

    # https://devenv.sh/languages/
    # languages.nix.enable = true;

    # https://devenv.sh/scripts/
    # scripts.hello.exec = /tdp/scripts/script.sh;

    # https://devenv.sh/pre-commit-hooks/
    # pre-commit.hooks.shellcheck.enable = true;

    # https://devenv.sh/processes/
    # processes.ping.exec = "ping example.com";
}
