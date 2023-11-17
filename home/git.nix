{ pkgs, ... }:
{
  programs.git =
    {
      aliases = {
        c = "commit";
        p = "push";
      };

      enable = true;

      extraConfig = {
        pull = {
          ff = "only";
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
        rebase = {
          autoStash = true;
          autoSquash = true;
        };
        # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md#git-protocol-error
        url = {
          "https://github.com" = {
            insteadOf = "git://github.com";
          };
        };
        core = {
          pager = "delta";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          navigate = true; # use n and N to move between diff sections
          light = false; # set to true if you're in a terminal w/ a light background color (e.g. the default macOS terminal)
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };

      includes = [
        {
          path = "~/code/dlh/.gitconfig";
          condition = "gitdir:~/code/dlh/";
        }
        {
          path = "~/code/dlh/plansee/.gitconfig";
          condition = "gitdir:~/code/dlh/plansee/";
        }
      ];

      signing = {
        signByDefault = true;
        key = "24575DB93F6CEC16";
      };

      ignores = [ ".idea" "nohup.out" "mzdata" ".vimspector.json" ];

      userEmail = "4farlion@gmail.com";

      userName = "workflow";
    };

}
