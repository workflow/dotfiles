# `herdr` is picked up from the user PATH (--close-tab, and tab cleanup under --all).
{
  writeShellApplication,
  jujutsu,
  gh,
  jq,
  coreutils,
  gnugrep,
  gnused,
}:
writeShellApplication {
  name = "jj-workspace-done";
  runtimeInputs = [jujutsu gh jq coreutils gnugrep gnused];
  text = builtins.readFile ./scripts/jj-workspace-done.sh;
}
