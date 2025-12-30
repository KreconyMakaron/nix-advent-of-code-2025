let
  lib = import <nixpkgs/lib>;
in
with lib;
with builtins;
let
  lines = filter (x: x != "") (splitString "\n" (readFile ./input/7.txt));

  boardLen = stringLength (head lines);

  getPositions =
    char: str:
    (foldl
      (s: x: {
        index = s.index + 1;
        result = s.result ++ (if x == char then [ s.index ] else [ ]);
      })
      {
        index = 0;
        result = [ ];
      }
      (stringToCharacters str)
    ).result;

  simulateLayer =
    state: layer:
    let
      splitters = filter (x: elem x layer) state.beams;
      notHit = subtractLists splitters state.beams;
    in
    {
      beams = unique (
        notHit
        ++ (filter (x: 0 <= x && x < boardLen) (
          flatten (
            map (x: [
              (x - 1)
              (x + 1)
            ]) splitters
          )
        ))
      );
      result = state.result + (length splitters);
    };

  simulate =
    board:
    (foldl simulateLayer {
      beams = getPositions "S" (head board);
      result = 0;
    } (map (x: getPositions "^" x) (tail board))).result;
in
simulate lines
