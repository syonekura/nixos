{channels, ...}: final: prev: let
  unstable = channels.nixpkgs-unstable;
in {
  darktable = unstable.darktable.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      unstable.onnxruntime
      unstable.libarchive
    ];
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ unstable.makeWrapper ];
    cmakeFlags = old.cmakeFlags ++ [
      "-DUSE_AI=ON"
      # avoid FindONNXRuntime.cmake trying to download its own copy in the
      # sandboxed Nix build; use the onnxruntime buildInput instead
      "-DONNXRUNTIME_OFFLINE=ON"
    ];
    # darktable dlopen()s libonnxruntime.so at runtime instead of linking
    # against it, so Nix's automatic rpath patching never picks it up -
    # without this it reports the AI runtime as undetectable.
    preFixup = (old.preFixup or "") + ''
      wrapProgram $out/bin/darktable \
        --prefix LD_LIBRARY_PATH : "${unstable.lib.getLib unstable.onnxruntime}/lib"
    '';
  });
}
