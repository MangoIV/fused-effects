{
  nixConfig.allow-import-from-derivation = true;
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };
  outputs = inputs:
    inputs.parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.haskell-flake.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        pre-commit = {
          check.enable = true;
          settings.hooks = {
            cabal-fmt.enable = true;
            fourmolu.enable = true;
            hlint.enable = false;

            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };
        haskellProjects.default = {
          packages = {};
          settings = {};
          devShell.mkShellArgs.shellHook = config.pre-commit.installationScript;
        };
        packages.default = config.packages.fused-effects;
        haskellProjects.ghc96 = {
          packages = {};
          settings = {};
          basePackages = pkgs.haskell.packages.ghc96;
          devShell.mkShellArgs.shellHook = config.pre-commit.installationScript;
        };
      };
    };
}
