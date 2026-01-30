{...}: {
  flake.modules.homeManager.less = {...}: {
    programs.less = {
      enable = true;
      config = ''
        k forw-line
        l back-line
      '';
    };
  };
}
