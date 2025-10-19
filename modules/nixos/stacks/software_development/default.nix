{
  lib,
  namespace,
  config,
  pkgs,
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
              lsp.display-inlay-hints = true;
              bufferline = "always";
              line-number = "relative";
            };
          };
          languages = {
            language = [
              {
                name = "nix";
                language-servers = ["nixd"];
                auto-format = true;
                formatter = {
                  command = "alejandra";
                };
              }
            ];
            language-server.nixd = {
              command = "nixd";
              args = ["--inlay-hints=true"];
              config.formatting.command = "alejandra";
            };
          };
        };

        vscode = {
          enable = true;
          profiles.default = {
            extensions = [
              pkgs.vscode-extensions.ms-python.python
              pkgs.vscode-extensions.ms-python.debugpy
              pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons
              pkgs.vscode-extensions.catppuccin.catppuccin-vsc
              pkgs.vscode-extensions.kamadorueda.alejandra
              pkgs.vscode-extensions.bbenoist.nix
              pkgs.vscode-extensions.jnoortheen.nix-ide
            ];

            userSettings = {
              "editor.fontFamily" = "'Fira Code Nerd Font', 'monospace', monospace";
              "editor.semanticHighlighting.enabled" = true;
              "editor.tabSize" = 2;

              "files.autoSave" = "afterDelay";
              "files.autoSaveDelay" = 1000;

              "window.zoomLevel" = 0.7;

              "nix.enableLanguageServer" = true;
              "nix.serverPath" = "nixd";
              "workbench.settings.applyToAllProfiles" = [
                "editor.fontSize"
                "editor.fontFamily"
                "window.zoomLevel"
              ];
              "explorer.confirmDelete" = false;
              "explorer.confirmDragAndDrop" = false;
              "git.autofetch" = true;
              "workbench.colorTheme" = "Catppuccin Mocha";
              "terminal.integrated.minimumContrastRatio" = 1;
              "window.titleBarStyle" = "custom";
              "workbench.iconTheme" = "catppuccin-mocha";
            };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      git
      qemu
      # Nix Language support
      nixd
      alejandra
      # Misc
      jq
      perl
      curl
    ];
  };
}
