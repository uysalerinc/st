{
  description = "My custom st (Simple Terminal) fork";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
      name = "st";
      src = self + "/src"; # Point to the `src` directory in your repository

      nativeBuildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        pkg-config
        ncurses # Add ncurses for the `tic` command
      ];

      buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        xorg.libX11
        xorg.libXft
        freetype
        fontconfig
        xorg.libXrender
      ];

      prePatch = ''
        sed -i 's@/usr/local@$out@g' config.mk
      '';

      installPhase = ''
        make PREFIX=$out install
      '';
    };
  };
}
