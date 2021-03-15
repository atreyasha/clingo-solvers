# Clingo solvers

This repository contains NxN-Sudoku, Yosenabe, Minotaur and Elevator game solvers implemented in [clingo](https://github.com/potassco/clingo). The report for the final elevator project can be found [here](./docs/asp_elevator.pdf).

## Dependencies

Install `clingo` onto your system, either via your package manager (recommended, if available) or [building from source](https://github.com/potassco/clingo/blob/master/INSTALL.md).

The source code in this repository was tested against `v5.3.0` of `clingo`.

## Usage

Source code for `clingo` solvers is available in the `src` directory. The `test` directory contains test instances of the respective games.

As an example, one can test the default 9x9 sudoku solver by executing:

```shell
$ clingo ./test/test_sudoku.lp ./src/sudoku.lp 0
```

## Known issue(s)

Based on local experiments, all solvers except the Minotaur solver in `minotaur.lp` and/or `minotaur_alternative.lp` succeeded in Yeti benchmark tests. Pull requests for an improved Minotaur solver are therefore very welcome.
