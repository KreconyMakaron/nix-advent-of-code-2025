let
  lib = import <nixpkgs/lib>;
  lines = lib.filter (x: x != "") (lib.splitString "\n" (builtins.readFile ./input/4.txt));

  symbols = map lib.stringToCharacters lines;

  lengthX = lib.length (lib.head symbols);
  lengthY = lib.length symbols;

  nums = map (row: row.row) (
    lib.zipListsWith (y: row: {
      inherit y;
      row =
        lib.zipListsWith (symbol: x: {
          inherit x y;
          sym =
            if symbol == "@"
            then 1
            else 0;
        })
        row (lib.range 0 (lengthX - 1));
    }) (lib.range 0 (lengthY - 1))
    symbols
  );

  get = y: x: r:
    if x < 0 || y < 0 || x >= lengthX || y >= lengthY
    then {
      inherit x y;
      sym = 0;
    }
    else lib.elemAt (lib.elemAt r y) x;

  count = pos: r:
    (get (pos.y - 1) (pos.x - 1) r).sym
    + (get (pos.y - 1) pos.x r).sym
    + (get (pos.y - 1) (pos.x + 1) r).sym
    + (get pos.y (pos.x - 1) r).sym
    + (get pos.y (pos.x + 1) r).sym
    + (get (pos.y + 1) (pos.x - 1) r).sym
    + (get (pos.y + 1) pos.x r).sym
    + (get (pos.y + 1) (pos.x + 1) r).sym;

  accessible = pos: r: (count pos r) < 4 && pos.sym == 1;

  countRolls = r: lib.foldl lib.add 0 (map (row: lib.length (lib.filter (pos: accessible pos r) row)) r);
  removeRolls = r:
    map (row:
      map (pos:
        if (accessible pos r)
        then {
          inherit (pos) x y;
          sym = 0;
        }
        else pos)
      row)
    r;
in
  lib.fix (self: r: let
    next = removeRolls r;
  in
    if next == r
    then countRolls r
    else (countRolls r) + (self next))
  nums
