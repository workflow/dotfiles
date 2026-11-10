{
  lib,
  rustPlatform,
  fetchFromGitHub,
  jjWorkspaceDirenvTrust,
}:
rustPlatform.buildRustPackage {
  pname = "herdr-plugin-jj-workspace";
  version = "0.4.0-unstable-2026-09-09";

  src = fetchFromGitHub {
    owner = "NathanFlurry";
    repo = "herdr-plugin-jj-workspace";
    rev = "ee71c3ce112ce97b494f4f77a92ac8589df12274";
    hash = "sha256-UOkUwBu1lFXzWGaURsw7bAG5IKoZRO4yJ1ia+m6js0o=";
  };
  cargoHash = "sha256-IQiS+IYHC6c5eBPsRZYyy6QeNv4b0jIDyUpjDHSi5Lk=";

  patches = [
    ./_patches/jj-workspace-local.patch
    ./_patches/jj-workspace-direnv-trust.patch
    ./_patches/jj-workspace-auto-update-stale.patch
    ./_patches/jj-workspace-pin-repo-label.patch
    ./_patches/jj-workspace-confirm-remove.patch
  ];
  postPatch = ''
    substituteInPlace src/main.rs --replace-fail @jjWorkspaceDirenvTrust@ ${lib.getExe jjWorkspaceDirenvTrust}
  '';

  # The output is the plugin root: herdr resolves the manifest's
  # `./target/release/...` commands against it.
  postInstall = ''
    install -Dm644 herdr-plugin.toml "$out/herdr-plugin.toml"
    mkdir -p "$out/target/release"
    ln -s "$out/bin/jj-workspace" "$out/target/release/jj-workspace"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    cd "$out"
    commands=$(grep -oE '^command = \["\./[^"]+"' herdr-plugin.toml | cut -d'"' -f2 | sort -u)
    [ -n "$commands" ] || { echo "no plugin-root commands found in herdr-plugin.toml" >&2; exit 1; }
    for command in $commands; do
      # Without arguments the plugin exits non-zero after printing its usage.
      output=$("$command" 2>&1 || true)
      [[ $output == "usage: jj-workspace"* ]] || { echo "$command does not run: $output" >&2; exit 1; }
    done
    cd - >/dev/null
    runHook postInstallCheck
  '';

  meta.mainProgram = "jj-workspace";
}
