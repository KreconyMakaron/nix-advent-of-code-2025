let
  lib = import <nixpkgs/lib>;
in
with lib;
with builtins;
let
  lines = filter (x: x != "") (splitString "\n" (readFile ./input/8.txt));

  points =
    zipListsWith
      (
        x: y:
        x
        // {
          index = y;
          size = 1;
          parent = y;
        }
      )
      (map (
        l:
        listToAttrs (
          zipListsWith (x: y: {
            name = x;
            value = y;
          }) [ "x" "y" "z" ] (map toInt (splitString "," l))
        )
      ) lines)
      (range 0 (length lines));

  distance =
    p1: p2:
    let
      sqDist = a: b: (a - b) * (a - b);
    in
    (sqDist p1.x p2.x) + (sqDist p1.y p2.y) + (sqDist p1.z p2.z);

  noRepeatSelfCross =
    f: l:
    flatten (
      map (
        x:
        crossLists f [
          [ (elemAt l x) ]
          (sublist (x + 1) (length l) l)
        ]
      ) (range 0 ((length l) - 1))
    );

  distances =
    pts:
    sort (x: y: lessThan x.dist y.dist) (
      noRepeatSelfCross (x: y: {
        p1 = x.index;
        p2 = y.index;
        dist = distance x y;
      }) pts
    );

  getPoint = pts: idx: elemAt pts idx;

  find =
    pts: idx:
    let
      inherit (getPoint pts idx) parent;
    in
    if idx == parent then idx else find pts parent;

  updatePoint =
    idx: new_val: pts:
    map (x: if x.index == idx then new_val else x) pts;

  union =
    i1: i2: pts:
    let
      a = find pts i1;
      b = find pts i2;

      u = getPoint pts a;
      v = getPoint pts b;

      a' = if u.size >= v.size then a else b;
      b' = if u.size >= v.size then b else a;

      u' = getPoint pts a';
      v' = getPoint pts b';
    in
    if a == b then
      pts
    else
      let
        pts' = updatePoint b' (
          v'
          // {
            size = 0;
            parent = a';
          }
        ) pts;
      in
      updatePoint a' (u' // { size = v.size + u.size; }) pts';

  fillNetwork =
    pts:
    let
      len = length pts;
    in
    foldl'
      (
        state: d:
        if any (p: p.size == len) state.pts then
          state
        else
          {
            iteration = state.iteration + 1;
            pts = union d.p1 d.p2 state.pts;
          }
      )
      {
        iteration = 0;
        inherit pts;
      }
      (distances pts);

  score =
    pts:
    let
      d = elemAt (distances pts) ((fillNetwork pts).iteration - 1);
      a = getPoint pts d.p1;
      b = getPoint pts d.p2;
    in
    a.x * b.x;
in
score points
