{...}: {
  flake.modules.homeManager.wealthfolio = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    wealthfolio = pkgs.unstable.wealthfolio.overrideAttrs (oldAttrs: rec {
      version = "3.1.2";

      src = pkgs.fetchFromGitHub {
        owner = "afadil";
        repo = "wealthfolio";
        rev = "v${version}";
        hash = "sha256-JLflqtT24VIGbMIndLqXApEkhbV1kEJT7FcBvO5Kx0g=";
      };

      pnpmDeps = pkgs.fetchPnpmDeps {
        inherit src;
        pname = "wealthfolio";
        inherit version;
        pnpm = pkgs.pnpm_9;
        fetcherVersion = 1;
        hash = "sha256-feM1jQsUDKVX4+x4Otdwx6AEM+FO7fiaJjmMbU6GDf8=";
      };

      cargoRoot = ".";
      buildAndTestSubdir = cargoRoot;

      cargoDeps = pkgs.unstable.rustPlatform.fetchCargoVendor {
        inherit src cargoRoot;
        pname = "wealthfolio";
        inherit version;
        hash = "sha256-r01/Y4l52gESRKbDGTY8tI8r5MRSyRHa77/+UV/4wV8=";
      };

      # glib-networking provides TLS support for WebKitGTK's fetch() calls.
      # Without it, all HTTPS requests from the webview fail with "Load failed".
      buildInputs = oldAttrs.buildInputs ++ [pkgs.unstable.glib-networking];

      postPatch = ''
        jq \
          '.plugins.updater.endpoints = [ ]
          | .bundle.createUpdaterArtifacts = false' \
          apps/tauri/tauri.conf.json \
          | sponge apps/tauri/tauri.conf.json

        # Enable Wealthfolio Connect: provide the production config so both the
        # Vite frontend (import.meta.env) and Rust build.rs (cargo:rustc-env)
        # pick up the auth endpoints at compile time.
        cat > .env <<'EOF'
CONNECT_AUTH_URL=https://auth.wealthfolio.app
CONNECT_AUTH_PUBLISHABLE_KEY=sb_publishable_ZSZbXNtWtnh9i2nqJ2UL4A_NV8ZVutd
CONNECT_API_URL=https://api.wealthfolio.app
CONNECT_OAUTH_CALLBACK_URL=https://connect.wealthfolio.app/deeplink
EOF
      '';
    });

  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/com.teymz.wealthfolio"
      ];
    };

    home.packages = [wealthfolio];
  };
}
