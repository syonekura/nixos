{...}: final: prev: {
  # Libraw snapshot 202403 needed for Canon R8 camera support on Darktable
  # https://github.com/darktable-org/darktable/releases/tag/release-4.8.0
  libraw = prev.libraw.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "LibRaw";
      repo = "LibRaw";
      rev = "12b0e5d60c57bb795382fda8494fc45f683550b8";
      hash = "sha256-2TBisALdSMOpPHm+g4gLkG5Ahot+fj0QN9yOybdzKw4=";
    };
  });
}
