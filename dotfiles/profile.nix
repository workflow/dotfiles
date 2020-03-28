{ pkgs }:

{
  path = ["$HOME/.local/bin" "$HOME/bin"];
  variables = {
    "EDITOR" = "vim";
  };
  aliases = {
    detach = "udisksctl power-off -b";
    rmpyc = "find . | grep -E '(__pycache__|.pyc|.pyo$)' | xargs rm -rf";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
  };
}
