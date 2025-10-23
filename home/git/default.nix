{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/glab-cli"
    ];
  };

  home.packages = with pkgs; [
    delta # Syntax highlighter for git
    github-cli
    glab
  ];

  home.file.".config/gh/config.yml".source = ./github-cli/gh.config.yml;

  programs.git = {
    aliases = {
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

    difftastic = {
      enable = true;
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

    ignores = [".idea" "nohup.out" "mzdata" ".vimspector.json"];

    userEmail = "4farlion@gmail.com";

    userName = "workflow";
  };

  programs.mergiraf = {
    enable = true;
  };
}
