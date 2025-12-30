let
  lib = import <nixpkgs/lib>;
in
with lib;
let
  lines = filter (x: x != "") (splitString "\n" (builtins.readFile ./input/5.txt));

  isRange = x: elem "-" (stringToCharacters x);

  ranges = map (x: {
    a = head x;
    b = last x;
  }) (map (x: map toInt (splitString "-" x)) (filter isRange lines));

  # sort by beginning
  sorted = sort (x: y: lessThan x.a y.a) ranges;

  base = {
    isInside = false;
    a = 0;
    b = -1;
    sum = 0;
  };

  step =
    cur: new:
    if cur.b < new.a then
      {
        # disjoint
        # a b a' b'
        inherit (new) a b;
        sum = cur.sum + cur.b - cur.a + 1;
      }
    else
      {
        # overlap
        # a a' b b' or a a' b' b
        inherit (cur) a sum;
        b = max cur.b new.b;
      };

  res = foldl step base sorted;
in
res.sum + res.b - res.a + 1
