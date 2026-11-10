{
  pkgs,
  jjWorkspaceDone,
}:
pkgs.runCommand "jj-workspace-done-test" {
  nativeBuildInputs = [jjWorkspaceDone pkgs.jujutsu pkgs.git pkgs.gnugrep];
} ''
  bash ${./scripts/jj-workspace-done-test.sh}
  touch "$out"
''
