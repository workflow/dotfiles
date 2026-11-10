{
  pkgs,
  jjWorkspaceDirenvTrust,
}:
pkgs.runCommand "jj-workspace-direnv-trust-test" {
  nativeBuildInputs = [jjWorkspaceDirenvTrust pkgs.jujutsu pkgs.direnv pkgs.jq];
} ''
  bash ${./scripts/jj-workspace-direnv-trust-test.sh}
  touch "$out"
''
