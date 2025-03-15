{...}: {
  home.file = {
    "bin/caffeinate" = {
      source = ./caffeinate.sh;
      executable = true;
    };
    "bin/decaffeinate" = {
      source = ./decaffeinate.sh;
      executable = true;
    };
  };
}
