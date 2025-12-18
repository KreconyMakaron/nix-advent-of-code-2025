let
  lib = import <nixpkgs/lib>;

  puzzle_input = lib.readFile ./1.txt;

  rotations = lib.filter (x: x != "") (lib.splitString "\n" puzzle_input);

  numbers = map (x:
    (
      if (lib.substring 0 1 x == "L")
      then -1
      else 1
    )
    * (lib.toInt (lib.substring 1 (-1) x)))
  rotations;

  mod = a: b: a - (b * (a / b));

  step = state: rotation: rec {
    pos = mod (state.pos + rotation) 100;
    count =
      state.count
      + (
        if pos == 0
        then 1
        else 0
      );
  };
in
  (lib.foldl' step {
      pos = 50;
      count = 0;
    }
    numbers).count
