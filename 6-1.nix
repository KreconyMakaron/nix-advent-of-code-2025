let
  lib = import <nixpkgs/lib>;
in
with lib;
with builtins;
let
  lines = filter (x: x != "") (splitString "\n" (readFile ./input/6.txt));
  grid = map (x: filter (y: y != " " && y != "") (splitString " " x)) lines;
  getNthRow = n: map (x: elemAt x n) grid;
  transposed = map getNthRow (range 0 ((length (head grid)) - 1));
  expressions = map (x: {
    op = last x;
    nums = map toInt (sublist 0 ((length x) - 1) x);
  }) transposed;

  evaluate = e: if e.op == "*" then foldl mul 1 e.nums else foldl add 0 e.nums;
in
foldl add 0 (map evaluate expressions)
