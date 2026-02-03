# Like rg, but also search in Office documents, PDFs etc...; rga-fzf is AMAZING!
{...}: {
  flake.modules.homeManager.ripgrep-all = {...}: {
    programs.ripgrep-all.enable = true;
  };
}
