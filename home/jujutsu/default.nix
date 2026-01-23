{pkgs, ...}: {
  programs.difftastic.enable = true;
  programs.jjui = {
    enable = true;
    package = pkgs.unstable.jjui;
  };
  programs.jujutsu = {
    enable = true;
    package = pkgs.unstable.jujutsu;
    settings = {
      remotes.origin.auto-track-bookmarks = "main";
      ui.diff-formatter = ["difft" "--color=always" "$left" "$right"];
      user = {
        email = "4farlion@gmail.com";
        name = "workflow";
      };
      signing = {
        backend = "gpg";
        key = "24575DB93F6CEC16";
        behavior = "own"; # sign commits you authored on modify
      };
      aliases = {
        bt = ["bookmark" "track"];
        c = ["commit"];
        init = ["git" "init" "--colocate"];
        push = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
            set -e

            # Check if current commit has both description and changes
            has_description=$(jj log -r @ --no-graph --color never -T 'description' | grep -q . && echo "yes" || echo "no")
            # Use 'empty' template keyword to check if commit has changes
            has_changes=$(jj log -r @ --no-graph --color never -T 'empty' | grep -q "false" && echo "yes" || echo "no")

            if [ "$has_description" = "yes" ] && [ "$has_changes" = "yes" ]; then
                echo "Current commit has description and changes, creating new commit..."
                jj new
            fi

            # Get the bookmark from the parent commit directly
            bookmark=$(jj log -r 'ancestors(@) & bookmarks()' -n 1 --no-graph --color never -T 'bookmarks' | sed 's/\*$//' | tr -d ' ')

            if [ -z "$bookmark" ]; then
                echo "No bookmark found on parent commit"
                exit 1
            fi

            echo "Moving bookmark '$bookmark' to parent commit and pushing..."
            jj bookmark set "$bookmark" -r @-
            jj git fetch
            jj git push --bookmark "$bookmark" --allow-new
          ''
        ];
      };
    };
  };
}
