let
  lib = import <nixpkgs/lib>;
in
with lib;
let
  lines = filter (x: x != "") (splitString "\n" (builtins.readFile ./input/5.txt));

  isRange = x: elem "-" (stringToCharacters x);

  ranges = map (x: map toInt (splitString "-" x)) (filter isRange lines);
  ids = map toInt (filter (x: !(isRange x)) lines);

  isInRange = x: any (y: (head y) <= x && x <= (last y)) ranges;
  fresh = filter isInRange ids;
in
length fresh
