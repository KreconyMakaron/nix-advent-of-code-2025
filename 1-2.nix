let
  lib = import <nixpkgs/lib>;

  puzzle_input = lib.readFile ./input/1.txt;

  rotations = lib.filter (x: x != "") (lib.splitString "\n" puzzle_input);

  numbers = map (x:
    (
      if (lib.substring 0 1 x == "L")
      then -1
      else 1
    )
    * (lib.toInt (lib.substring 1 (-1) x)))
  rotations;

  step = state: rotation: let
    new = state.pos + rotation;

    floorDiv = x: y:
      if x >= 0
      then x / y
      else - ((-x + y - 1) / y);

    ceilDiv = x: y:
      - (floorDiv (-x) y);

    sml = lib.min state.pos new;
    big = lib.max state.pos new;
  in rec {
    pos = lib.mod new 100;
    count =
      state.count
      + (floorDiv (big - 1) 100)
      - (ceilDiv (sml + 1) 100)
      + 1
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
