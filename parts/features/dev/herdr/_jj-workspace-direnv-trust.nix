{
  writeShellApplication,
  jujutsu,
  direnv,
  jq,
  coreutils,
  diffutils,
}:
writeShellApplication {
  name = "jj-workspace-direnv-trust";
  runtimeInputs = [jujutsu direnv jq coreutils diffutils];
  text = builtins.readFile ./scripts/jj-workspace-direnv-trust.sh;
}
