{ lib, hasTag }:
[
  (lib.mkIf (hasTag "speqtral") {
    name = "SpeQtral";
    bookmarks = [
      {
        name = "My Agile (All Projects)";
        url = "http://10.1.5.5:3000/agile/board?set_filter=1&f%5B%5D=assigned_to_id&op%5Bassigned_to_id%5D=%3D&v%5Bassigned_to_id%5D%5B%5D=me&f_status%5B%5D=1&f_status%5B%5D=7&f_status%5B%5D=2&f_status%5B%5D=4&f_status%5B%5D=18&f_status%5B%5D=8&f_status%5B%5D=11&f_status%5B%5D=10&f_status%5B%5D=6&f_status%5B%5D=9&c%5B%5D=project&c%5B%5D=tracker&c%5B%5D=done_ratio&c%5B%5D=parent";
      }
      {
        name = "pve-qnex-apps";
        url = "pve-qnex-apps.speqtranet.com:8006";
      }
      {
        name = "GitHub Actions Runners";
        url = "https://github.com/organizations/SpeQtral/settings/actions/runners";
      }
    ];
  })
  {
    name = "Cycling";
    bookmarks = [
      {
        name = "Pedalah";
        url = "https://pedalah.com/";
      }
    ];
  }
  {
    name = "Nix";
    bookmarks = [
      {
        name = "home-manager options";
        url = "https://nix-community.github.io/home-manager/options.xhtml";
      }
      {
        name = "Nix Packages";
        url = "https://search.nixos.org/packages?channel=unstable&";
      }
      {
        name = "Nix Options";
        url = "https://search.nixos.org/options?channel=unstable&";
      }
    ];
  }
  {
    name = "C++";
    bookmarks = [
      {
        name = "cppreference";
        url = "https://en.cppreference.com/w/";
      }
      {
        name = "C++ Standard Draft";
        url = "https://eel.is/c++draft/";
      }
      {
        name = "cpp-grail";
        url = "https://bashar-ahmed.github.io/cpp-grail/";
      }
    ];
  }
]
