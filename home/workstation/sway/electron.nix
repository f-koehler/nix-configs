_: {
  xdg.desktopEntries.code = {
    name = "Visual Studio Code";
    genericName = "Code editor";
    exec = "code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
    terminal = false;
    categories = [
      "Utility"
      "TextEditor"
      "Development"
      "IDE"
    ];
    mimeType = [
      "text/plain"
      "inode/directory"
    ];
    comment = "Code Editing. Redefined.";
    icon = "vscode";
    startupNotify = true;
    type = "Application";

    actions."new-empty-window" = {
      exec = "code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland --new-window %F";
      icon = "vscode";
      name = "New Empty Window";
    };
  };
}
