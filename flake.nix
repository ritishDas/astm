{
  description = "Asset Manager (astm)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # Dev shell for development
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.gcc
          pkgs.nlohmann_json
        ];
        shellHook = ''
          echo "✅ Asset Manager dev shell ready!"
        '';
      };

      # Buildable package
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "astm";
        version = "1.0";

        src = ./.;
        nativeBuildInputs = [ pkgs.gcc ];
        buildInputs = [ pkgs.nlohmann_json ];

        buildPhase = ''
          mkdir -p build
          g++ -std=c++17 -O2 astm.cpp -o build/astm
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp build/astm $out/bin/
          
        mkdir -p $out/share/bash-completion/completions

        cp completions/astm.bash $out/share/bash-completion/completions/astm
        '';
      };
    };
}

