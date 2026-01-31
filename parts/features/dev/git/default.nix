{...}: {
  flake.modules.homeManager.git = {pkgs, lib, osConfig, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".config/glab-cli"];
    };

    home.packages = with pkgs; [
      delta
      github-cli
      glab
    ];

    home.file.".config/gh/config.yml".source = ./gh.config.yml;

    programs.difftastic = {
      enable = true;
      git.enable = true;
    };

    programs.git = {
      enable = true;

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

      settings = {
        alias = {
          c = "commit";
          dlog = "-c diff.external=difft log --ext-diff";
          dshow = "-c diff.external=difft show --ext-diff";
          ddiff = "-c diff.external=difft diff";
          dl = "-c diff.external=difft log -p --ext-diff";
          ds = "-c diff.external=difft show --ext-diff";
          dft = "-c diff.external=difft diff";
          p = "push";
          rim = "rebase -i main";
          rimm = "rebase -i master";
        };

        core.pager = "delta";
        diff.colorMoved = "default";
        init.defaultBranch = "main";
        interactive.diffFilter = "delta --color-only";
        merge.conflictstyle = "diff3";
        pull = {
          ff = "only";
          rebase = true;
        };
        rebase = {
          autoStash = true;
          autoSquash = true;
        };
        url."https://github.com".insteadOf = "git://github.com";
        user.email = "4farlion@gmail.com";
        user.name = "workflow";
      };

      ignores = [".idea" "nohup.out" "mzdata" ".vimspector.json"];
    };

    programs.mergiraf.enable = true;
  };
}
