{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/Todoist"
    ];
  };

  home.packages = [
    pkgs.todoist-electron
  ];

  # Create a custom desktop entry with proper Wayland/Electron flags
  # This fixes the segfault when launching via fuzzel or other app launchers
  xdg.desktopEntries.todoist = {
    name = "Todoist";
    comment = "The world's #1 task manager and to-do list app";
    exec = "todoist-electron --ozone-platform-hint=auto %U";
    icon = "com.todoist.Todoist";
    terminal = false;
    categories = ["Office" "ProjectManagement"];
    mimeType = ["x-scheme-handler/todoist"];
    startupNotify = true;
  };
}
