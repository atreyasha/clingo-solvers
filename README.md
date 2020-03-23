# Game solvers implemented in clingo

This repository contains NxN-Sudoku, Yosenabe, Minotaur and Elevator game solvers implemented in clingo (https://github.com/potassco/clingo).

## Guide for implementation

1. Install clingo onto your system (https://github.com/potassco/clingo/blob/master/INSTALL.md).

2. Clone this repository and navigate into its main directory:

   ```shell
   $ git clone https://github.com/atreyasha/clingoSolvers && cd clingoSolvers
   ```

3. The directory `/initial` contains test instances of the games. You can test the the default 9x9 sudoku solver (for example) as shown below:

   ```shell
   $ clingo ./initial/initialSudoku.lp sudoku.lp 0
   ```

## Vim configuration for clingo

In order to get syntax highlighting for clingo/gringo in vim, simply copy the 3 folders inside the local `vim/` directory into your `~/.vim` directory.

Source and further information: https://sourceforge.net/p/potassco/code/HEAD/tree/trunk/vim-syntax-gringo/
