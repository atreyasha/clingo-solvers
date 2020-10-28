% define size of subgrid, which is the square root of row/column length
#const n=3.

% define generic parameters
grid(1..n*n,1..n*n).
v(1..n*n).

% define variables
initial(X,Y,(((X-1)/n)*n + (Y-1)/n),V) :- initial(X,Y,V).
sudoku(X,Y,S,V) :- initial(X,Y,S,V).

% find remaining squares to be filled
gridR(X,Y) :- grid(X,Y), not initial(X,Y,_,_).
gridR(X,Y,(((X-1)/n)*n + (Y-1)/n)) :- gridR(X,Y).

% define possibilities, important lines here to control combinatorical explosion
{sudoku(X,Y,S,V): v(V), not initial(X,_,_,V), not initial(_,Y,_,V), not initial(_,_,S,V)} = 1 :- gridR(X,Y,S).

% assign constraints
:-#sum{1,X,V:sudoku(X,Y,S,V)} != n*n, X=(1..n*n).
:-#sum{1,Y,V:sudoku(X,Y,S,V)} != n*n, Y=(1..n*n).
:-#sum{1,S,V:sudoku(X,Y,S,V)} != n*n, S=(0..n*n-1).

% project and print
sudoku(X,Y,V) :- sudoku(X,Y,S,V).
#show sudoku/3.
