# Shared by the home-manager, NixOS and nix-darwin module sets. Tags are set
# once per node in flake.nix and exposed to every module as `hasTag`.
{ lib, config, ... }:
{
  options.nodeTags = lib.mkOption {
    type = lib.types.listOf (
      lib.types.enum [
        # context
        "speqtral" # employer machine: work accounts, VPN hosts, AWS
        "personal" # private machine: personal accounts and media

        # form factor
        "laptop" # battery, lid, suspend, wifi, power profiles
        "desktop" # always on mains, no battery handling

        # capabilities
        "gpu-nvidia" # proprietary driver and CUDA tooling
      ]
    );
    default = [ ];
    description = "Tags describing this node's role, used to conditionally enable modules.";
  };

  config._module.args = {
    hasTag = tag: lib.elem tag config.nodeTags;
    hasAnyTagOf = tags: lib.any (tag: lib.elem tag config.nodeTags) tags;
  };
}
