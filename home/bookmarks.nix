{ lib, hasTag }:
[
  (lib.mkIf (hasTag "speqtral") {
    name = "SpeQtral";
    bookmarks = [
      {
        name = "Redmine (All Projects)";
        url = "http://10.1.5.5:3000/agile/board?set_filter=1&f%5B%5D=assigned_to_id&op%5Bassigned_to_id%5D=%3D&v%5Bassigned_to_id%5D%5B%5D=me&f%5B%5D=status_id&op%5Bstatus_id%5D=%3D&f_status%5B%5D=1&f_status%5B%5D=7&f_status%5B%5D=2&f_status%5B%5D=4&f_status%5B%5D=8&f_status%5B%5D=11&f_status%5B%5D=10&f_status%5B%5D=6&f_status%5B%5D=9&f_status%5B%5D=12&f_status%5B%5D=16&f_status%5B%5D=17&c%5B%5D=tracker&c%5B%5D=estimated_hours&c%5B%5D=spent_hours&c%5B%5D=done_ratio&c%5B%5D=parent&c%5B%5D=assigned_to&c%5B%5D=cf_4&c%5B%5D=cf_3";
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
