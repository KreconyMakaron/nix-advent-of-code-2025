let
  lib = import <nixpkgs/lib>;

  lines = lib.filter (x: x != "") (lib.splitString "\n" (builtins.readFile ./3.txt));

  banks = map (bank: map lib.toInt bank) (map lib.stringToCharacters lines);

  maxList = list:
    lib.foldl (state: cur:
      if cur > state.max
      then rec {
        max = cur;
        index = cnt;
        cnt = state.cnt + 1;
      }
      else {
        inherit (state) max index;
        cnt = state.cnt + 1;
      })
    {
      max = -1;
      index = -1;
      cnt = 0;
    }
    list;

  getNum = list:
    (lib.foldl (state: len: let
        max = maxList (lib.sublist state.index (len - state.index) list);
      in {
        value = 10 * state.value + max.max;
        index = state.index + max.index;
      }) {
        value = 0;
        index = 0;
      } (lib.reverseList (map (x: (lib.length list) - x) (lib.range 0 11)))).value;
in
  lib.foldl lib.add 0 (map getNum banks)
