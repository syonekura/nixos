# Upstream package ships its .desktop/icon/metainfo files nested under
# lib/python3.*/site-packages/share instead of $out/share, so Nix never
# symlinks them into the system profile and the app doesn't show up in
# the GNOME app grid. Re-expose them at the standard location.
_: final: prev: {
  rapid-photo-downloader = prev.rapid-photo-downloader.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        for d in applications icons metainfo; do
          for nested in "$out"/lib/python3*/site-packages/share/"$d"; do
            if [ -d "$nested" ]; then
              mkdir -p "$out/share"
              cp -r "$nested" "$out/share/$d"
            fi
          done
        done

        # No icon theme file is shipped either; the app's own svg lives
        # alongside its Python sources.
        for icon in "$out"/lib/python3*/site-packages/raphodo/data/rapid-photo-downloader.svg; do
          if [ -f "$icon" ]; then
            install -Dm444 "$icon" "$out/share/icons/hicolor/scalable/apps/rapid-photo-downloader.svg"
          fi
        done
      '';
  });
}
