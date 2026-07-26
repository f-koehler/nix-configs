{ lib, config, ... }:
{
  options.nodeTags = lib.mkOption {
    type = lib.types.listOf (
      lib.types.enum [
        "speqtral"
      ]
    );
    default = [ ];
    description = "Tags describing this node's role, used to conditionally enable modules.";
  };

  config._module.args.hasTag = tag: lib.elem tag config.nodeTags;
}
