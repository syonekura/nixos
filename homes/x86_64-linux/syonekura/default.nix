{pkgs, ...}: {
  # Most users should never change this value after the initial install, for any reason, even if you've upgraded
  # your system to a new NixOS release. This value does not affect the Nixpkgs version your packages and OS are
  # pulled from, so changing it will not upgrade your system. The state version indicates which default settings
  # are in effect and will therefore help avoid breaking program configurations. Switching to a higher state
  # version typically requires performing some manual steps, such as data conversion or moving files.
  # https://mynixos.com/nixpkgs/option/system.stateVersion
  # https://mynixos.com/home-manager/option/home.stateVersion

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    vlc
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

      # VLC as default video player
      "video/mp4" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "video/quicktime" = "vlc.desktop";
      "video/x-msvideo" = "vlc.desktop";
      "video/x-ms-wmv" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/x-flv" = "vlc.desktop";
      "video/3gpp" = "vlc.desktop";
      "video/ogg" = "vlc.desktop";
    };
  };
}
