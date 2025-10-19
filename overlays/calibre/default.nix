# https://github.com/NixOS/nixpkgs/issues/445447
{channels, ...}: final: prev: {inherit (channels.nixpkgs-unstable) calibre;}
