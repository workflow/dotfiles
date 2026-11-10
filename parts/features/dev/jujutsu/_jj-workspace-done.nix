# `herdr` is picked up from the user PATH when --close-tab is used inside a tab.
{
  writeShellApplication,
  jujutsu,
  gh,
  coreutils,
  gnugrep,
  gnused,
}:
writeShellApplication {
  name = "jj-workspace-done";
  runtimeInputs = [jujutsu gh coreutils gnugrep gnused];
  text = builtins.readFile ./scripts/jj-workspace-done.sh;
}
