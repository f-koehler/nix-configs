{ lib }:
let
  resolveMkIf =
    item:
    if builtins.isAttrs item && (item._type or null) == "if" then
      if item.condition then resolveMkIf item.content else null
    else
      item;

  # A node is either:
  # - the string "separator" (dropped)
  # - a folder: `{ name, bookmarks = [ ... ]; }` (flattened, name dropped)
  # - a bookmark: `{ name, url, ... }` (kept as `name = url;`)
  flattenNode =
    item:
    let
      resolved = resolveMkIf item;
    in
    if resolved == null || resolved == "separator" then
      { }
    else if resolved ? bookmarks then
      flattenList resolved.bookmarks
    else
      { ${resolved.name} = resolved.url; };

  flattenList = items: lib.foldl' (acc: item: acc // flattenNode item) { } items;
in
flattenList
