{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };
 
  outputs = { self, nixpkgs, ... }@inputs: inputs.utils.lib.eachSystem [
    "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"
  ] (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [];
      config.allowUnfree = true;
    };
    getLibFolder = pkg: "${pkg}/lib";
    libiconvPath = "${pkgs.libiconv}/lib";
  in {
    devShells.default = pkgs.mkShell rec {
      name = "ecrous";
      buildInputs = with pkgs; [
        # Rust utilities
        rustc
        cargo
        trunk
        rustfmt
        rust-analyzer
        wasm-bindgen
        
        # Node & Tailwindcss
        tailwindcss
        nodePackages_latest.pnpm

        # LLVM and Clang
        lldb
        cmake
        clang-tools
        cmakeCurses
        llvmPackages.llvm
        llvmPackages.clang
        llvmPackages.lld
      ];
      
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        (getLibFolder pkgs.llvmPackages.llvm)
        libiconvPath
      ];

      NIX_LDFLAGS = "-L${libiconvPath} -L${./lib}";
      CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "lld";

      # Terminaldagi muhitni ishlash uchun kerakli qismlar sozlash.
      shellHook = let
        icon = "(* ^ ω ^)";
      in ''
        export PS1="\[$(tput setaf 1)\]$(echo -e '${icon}')\[$(tput setaf 2)\] {\[$(tput setaf 3)\]\w\[$(tput setaf 2)\]} \[$(tput setaf 5)\](${name})\[$(tput setaf 6)\] \\$ -> \[$(tput sgr0)\]"

        # Let's make some announcements
        figlet -f slant ${name} | lolcat
        printf "\n"
        printf "Welcome to ${name}'es development environment!\n" | lolcat
        printf "\n"
      '';
    };
  });

}
