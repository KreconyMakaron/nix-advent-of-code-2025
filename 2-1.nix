let
  lib = import <nixpkgs/lib>;

  puzzle_input = lib.replaceStrings [ "\n" ] [ "" ] (builtins.readFile ./input/2.txt);
  ranges = lib.map (pair: lib.splitString "-" pair) (lib.splitString "," puzzle_input);

  evenDigits = s: lib.mod (lib.stringLength s) 2 == 0;
  splitInHalf = s: [
    (lib.substring 0 ((lib.stringLength s) / 2) s)
    (lib.substring ((lib.stringLength s) / 2) (-1) s)
  ];

  roundUp = s: "1" + (lib.strings.replicate (lib.stringLength (builtins.toString s)) "0");
  roundDown = s: lib.strings.replicate (lib.stringLength (builtins.toString s) - 1) "9";

  getNum =
    x: round:
    let
      s = builtins.toString x;
      rounded = if (evenDigits s) then s else round s;
      split = splitInHalf rounded;
      left = lib.toIntBase10 (lib.elemAt split 0);
      right = lib.toIntBase10 (lib.elemAt split 1);
    in
    if left == right then
      left
    else if right > left then
      left + 1
    else
      left;

  evaluate =
    x: y:
    lib.foldl' (
      prev: cur:
      let
        num = lib.toIntBase10 ((builtins.toString cur) + (builtins.toString cur));
      in
      prev + (if (lib.toIntBase10 x) <= num && num <= (lib.toIntBase10 y) then num else 0)
    ) 0 (lib.range (getNum x roundUp) (getNum y roundDown));
in
lib.foldl' (prev: cur: prev + (evaluate (lib.elemAt cur 0) (lib.elemAt cur 1))) 0 ranges
