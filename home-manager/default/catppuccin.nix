let
  inherit (builtins) isString attrNames listToAttrs elemAt;

  defaultFlavor = "macchiato";

  toCatppuccinFriendly = list: list
  |> map (x: let
    name =
      if isString x then
        x
      else elemAt (attrNames x) 0;
    flavor =
      if isString x || isString x.${name} then
        null
      else elemAt (attrNames x.${name}) 0;
    accent =
      if isString x then
        null
      else if isNull flavor && isString x.${name} then
        x.${name}
      else x.${name}.${flavor};
  in {
      inherit name;
      value = {
        enable = true;
        flavor = if isNull flavor then defaultFlavor else flavor;
      } // (if isNull accent || accent == "" then {} else { inherit accent; });
  }) |> listToAttrs;

in toCatppuccinFriendly [
  "fzf"
  { lazygit = "teal"; }
  "sway"
  { gh-dash = "teal"; }
  "btop"
  { bat.mocha = ""; }
]
