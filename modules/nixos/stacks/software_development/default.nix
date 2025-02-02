{
  lib,
  namespace,
  config,
  pkgs,
  inputs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.software;
in {
  options.${namespace}.modules.software.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    snowfallorg.users.syonekura = {
      home.config.programs = {
        git = {
          enable = true;
          userEmail = "sebastian.yonekura@gmail.com";
          userName = "Sebastian Yonekura";
        };

        helix = {
          defaultEditor = true;
          enable = true;
          settings = {
            theme = "catppuccin_mocha";
            editor = {
              bufferline = "always";
            };
          };
        };

        vscode = {
          enable = true;
          extensions = [
            pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons
            pkgs.vscode-extensions.catppuccin.catppuccin-vsc
            pkgs.vscode-extensions.kamadorueda.alejandra
            pkgs.vscode-extensions.bbenoist.nix
            pkgs.vscode-extensions.jnoortheen.nix-ide
          ];
          userSettings = {
            editor.fontFamily = "'Fira Code Nerd Font', 'monospace', monospace";
            editor.tabSize = 2;

            window.zoomLevel = 0.3;

            nix.enableLanguageServer = true;
            nix.serverPath = "nil";
            workbench.settings.applyToAllProfiles = [
              "editor.fontSize"
              "editor.fontFamily"
              "window.zoomLevel"
            ];
            explorer.confirmDelete = false;
            explorer.confirmDragAndDrop = false;
            git.autofetch = true;
            workbench.colorTheme = "Catppuccin Mocha";
            editor.semanticHighlighting.enabled = true;
            terminal.integrated.minimumContrastRatio = 1;
            window.titleBarStyle = "custom";
            workbench.iconTheme = "catppuccin-mocha";
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      git
      qemu
      jetbrains.pycharm-professional
      # Plugin support is limited to a predefined list, check
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
      # and it's readme. Forking + running update_plugins.py might be needed
      #(pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.pycharm-professional ["catppuccin"])
      jetbrains.rust-rover
      devenv
      nixd
    ];
  };
}
