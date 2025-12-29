let
  lib = import <nixpkgs/lib>;
in
  with lib;
  with builtins; let
    lines = filter (x: x != "") (splitString "\n" (readFile ./input/6.txt));
    grid = map stringToCharacters lines;

    getColumn = n: xs: map (x: elemAt x n) xs;
    transpose = xs: map (n: getColumn n xs) (range 0 ((length (head xs)) - 1));

    parseNum = l: trim (concatStrings (filter (x: x != " ") l));

    parse = l: let
      opStr = last l;
    in {
      op =
        if opStr == " "
        then null
        else opStr;
      num = parseNum (sublist 0 ((length l) - 1) l);
    };

    step = state: line:
      if line.op == null
      then {
        nums = state.nums ++ [line.num];
        inherit (state) sum;
      }
      else let
        numbers = map toInt (filter (x: (trim x) != "") (state.nums ++ [line.num]));
        eval = nums: op:
          if op == "+"
          then foldl add 0 nums
          else foldl mul 1 nums;
      in {
        sum = state.sum + (eval numbers line.op);
        nums = [];
      };

    list = map parse (reverseList (transpose grid));
  in
    (foldl step {
        nums = [];
        sum = 0;
      }
      list).sum
