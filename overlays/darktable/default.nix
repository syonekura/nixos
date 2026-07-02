{channels, ...}: final: prev: {
  darktable = channels.nixpkgs-unstable.darktable.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ channels.nixpkgs-unstable.onnxruntime ];
    cmakeFlags = old.cmakeFlags ++ [ "-DUSE_AI=ON" ];
  });
}
