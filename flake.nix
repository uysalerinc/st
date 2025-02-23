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
        # Create a temporary directory for terminfo files
        TERMINFO=$out/share/terminfo
        mkdir -p $TERMINFO

        # Install st binary and man page
        mkdir -p $out/bin
        cp -f st $out/bin
        chmod 755 $out/bin/st

        mkdir -p $out/share/man/man1
        sed "s/VERSION/0.9.2/g" < st.1 > $out/share/man/man1/st.1
        chmod 644 $out/share/man/man1/st.1

        # Compile and install terminfo files
        tic -sx -o $TERMINFO st.info
      '';
    };
  };
}
