let
  lib = import <nixpkgs/lib>;

  puzzle_input = lib.replaceStrings [ "\n" ] [ "" ] (builtins.readFile ./input/2.txt);
  ranges = lib.map (pair: lib.splitString "-" pair) (lib.splitString "," puzzle_input);

  isValidForPrefix =
    x: pref:
    let
      len = lib.stringLength x;
    in
    if (lib.mod len pref) == 0 then
      (lib.strings.replicate (len / pref) (lib.substring 0 pref x)) == x
    else
      false;

  isValid =
    x:
    lib.foldl' (prev: pref: prev || (isValidForPrefix x pref)) false (
      lib.range 1 ((lib.stringLength x) - 1)
    );

  sumRange =
    x: y:
    lib.foldl' (prev: num: prev + (if (isValid (builtins.toString num)) then num else 0)) 0 (
      lib.range (lib.toIntBase10 x) (lib.toIntBase10 y)
    );
in
lib.foldl' (prev: cur: prev + (sumRange (lib.elemAt cur 0) (lib.elemAt cur 1))) 0 ranges
