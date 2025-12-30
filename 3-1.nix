let
  lib = import <nixpkgs/lib>;

  lines = lib.filter (x: x != "") (lib.splitString "\n" (builtins.readFile ./input/3.txt));

  banks = map (bank: map lib.toInt bank) (map lib.stringToCharacters lines);

  maxList =
    list:
    lib.foldl
      (
        state: cur:
        if cur > state.max then
          rec {
            max = cur;
            index = cnt;
            cnt = state.cnt + 1;
          }
        else
          {
            inherit (state) max index;
            cnt = state.cnt + 1;
          }
      )
      {
        max = -1;
        index = -1;
        cnt = 0;
      }
      list;

  getNum =
    list:
    let
      first = maxList (lib.sublist 0 ((lib.length list) - 1) list);
      second = maxList (lib.sublist first.index (lib.length list) list);
    in
    10 * first.max + second.max;
in
lib.foldl lib.add 0 (map getNum banks)
