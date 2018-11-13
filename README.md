# Sudoku solver for 9x9 grid

This repository contains a sudoku solver algorithm implemented in clingo (https://github.com/potassco/clingo).

## Guide for implementation

1. Install clingo onto your system (https://github.com/potassco/clingo/blob/master/INSTALL.md).

2. Clone this repository and navigate into its main directory:

   ```shell
   $ git clone https://github.com/AtreyaSh/sudokuSolver && cd sudokuSolver
   ```

3. The file `initial.lp` should contain input instances of the sudoku puzzle. These should be written in the form `initial(X,Y,V)`, where X and Y are x and y-coordinates and V represents the value of a cell; all with ranges of `[1,9]`. You can input your initial instances directly into `initial.lp`.

4. Run the sudoku solver:

   ```shell
   $ clingo-5.3.0 initial.lp sudokuSolver.lp 0
   ```

## Vim configuration for clingo

In order to get syntax highlighting for clingo/gringo in vim, simply copy the 3 folders inside the local `vim/` directory into your `~/.vim` directory.
