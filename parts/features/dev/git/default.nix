{...}: {
  flake.modules.homeManager.git = {pkgs, lib, osConfig, ...}: let
    # Git init template that makes .git/info/exclude a symlink to
    # .gitignore.local in the repo root, so per-repo local ignores
    # are picked up automatically.
    gitTemplate = pkgs.runCommand "git-template" {} ''
      mkdir -p $out/info
      ln -s ../../.gitignore.local $out/info/exclude
    '';
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".config/glab-cli"];
      files = [".config/gh/hosts.yml"];
    };

    home.packages = with pkgs; [
      delta # Syntax highlighter for git
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

          # Difftastic
          dlog = "-c diff.external=difft log --ext-diff";
          dshow = "-c diff.external=difft show --ext-diff";
          ddiff = "-c diff.external=difft diff";
          # `git log` with patches shown with difftastic.
          dl = "-c diff.external=difft log -p --ext-diff";
          # Show the most recent commit with difftastic.
          ds = "-c diff.external=difft show --ext-diff";
          # `git diff` with difftastic.
          dft = "-c diff.external=difft diff";

          p = "push";
          rim = "rebase -i main";
          rimm = "rebase -i master";
        };

        core.pager = "delta";
        diff.colorMoved = "default";
        init.defaultBranch = "main";
        init.templateDir = "${gitTemplate}";
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
        # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md#git-protocol-error
        url."https://github.com".insteadOf = "git://github.com";
        user.email = "4farlion@gmail.com";
        user.name = "workflow";
      };

      ignores = [".idea" "nohup.out" "mzdata" ".vimspector.json" ".gitignore.local"];
    };

    programs.mergiraf.enable = true;
  }; # closes `in {`
}
