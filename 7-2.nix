let
  lib = import <nixpkgs/lib>;
in
  with lib;
  with builtins; let
    lines = filter (x: x != "") (splitString "\n" (readFile ./input/7.txt));

    boardLen = stringLength (head lines);

    getPositions = char: str:
      (foldl (s: x: {
          index = s.index + 1;
          result =
            s.result
            ++ (
              if x == char
              then [s.index]
              else []
            );
        }) {
          index = 0;
          result = [];
        } (stringToCharacters str)).result;

    simulateLayer = timelines: layer: let
      removeOutliers = l: filter (x: 0 <= x && x < boardLen) l;
      splitL = unique (removeOutliers (map (x: x - 1) layer));
      splitR = unique (removeOutliers (map (x: x + 1) layer));

      timelinesL = genList (x:
        if elem x splitL
        then elemAt timelines (x + 1)
        else 0)
      boardLen;
      timelinesR = genList (x:
        if elem x splitR
        then elemAt timelines (x - 1)
        else 0)
      boardLen;
      timelinesU = genList (x:
        if elem x layer
        then 0
        else elemAt timelines x)
      boardLen;
    in
      foldl (zipListsWith add) timelinesU [timelinesL timelinesR];

    simulate = board:
      foldl simulateLayer (genList (x:
        if elem x (getPositions "S" (head board))
        then 1
        else 0)
      boardLen) (map (x: getPositions "^" x) (tail board));
  in
    foldl add 0 (simulate lines)
