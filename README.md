# Advent of Nix
This repo is my humble attempt at completeing all of the [Advent of Code 2025](https://adventofcode.com/2025) using the [Nix](http://nix.dev/) purely functional programming language.

Why? good question.

# Running
Get your input, name it `<task_number>.txt` and put it under `input/`. 

Then you can run the solution using this command:
```bash
NIX_CONFIG="max-call-depth = 100000" nix-instantiate --eval --strict <solution_name>.nix 
```

You need to increase the `max-call-depth` by a lot because no one forsaw an idiot using this language to solve actual programming problems.

Additionally, because of the outright silly amount of recursive calls the code is far from perfromant... \
For example, `4-2.nix` takes around 25 seconds to run on my system.
