let
  lib = import <nixpkgs/lib>;
  lines = lib.filter (x: x != "") (lib.splitString "\n" (builtins.readFile ./input/4.txt));

  symbols = map lib.stringToCharacters lines;
  nums = map (row: map (symbol: if symbol == "@" then 1 else 0) row) symbols;

  lengthX = lib.length (lib.head symbols);
  lengthY = lib.length symbols;

  get =
    y: x:
    if x < 0 || y < 0 || x >= lengthX || y >= lengthY then 0 else lib.elemAt (lib.elemAt nums y) x;

  coordinates = lib.crossLists (y: x: { inherit x y; }) [
    (lib.range 0 (lengthY - 1))
    (lib.range 0 (lengthX - 1))
  ];

  rolls = lib.filter (pos: (get pos.y pos.x) == 1) coordinates;

  count =
    y: x:
    (get (y - 1) (x - 1))
    + (get (y - 1) x)
    + (get (y - 1) (x + 1))
    + (get y (x - 1))
    + (get y (x + 1))
    + (get (y + 1) (x - 1))
    + (get (y + 1) x)
    + (get (y + 1) (x + 1));
in
lib.foldl lib.add 0 (map (pos: if (count pos.y pos.x) < 4 then 1 else 0) rolls)
