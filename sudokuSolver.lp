% define generic parameters
x(1..9).
y(1..9).
v(1..9).
grid(1..9,1..9).

% define variables
initial(X,Y,(((X-1)/3)*3 + (Y-1)/3),V) :- initial(X,Y,V).
sudoku(X,Y,S,V) :- initial(X,Y,S,V).

% find remaining squares to be filled
gridR(X,Y) :- grid(X,Y), not initial(X,Y,_,_).
gridR(X,Y,(((X-1)/3)*3 + (Y-1)/3)) :- gridR(X,Y).

% define possibilities, important lines here to control combinatorical explosion
{sudoku(X,Y,S,V): v(V), not initial(X,_,_,V), not initial(_,Y,_,V), not initial(_,_,S,V)} = 1 :- gridR(X,Y,S).

% assign constraints
:-#sum{1,X,V:sudoku(X,Y,S,V)} != 9, X=(1..9).
:-#sum{1,Y,V:sudoku(X,Y,S,V)} != 9, Y=(1..9).
:-#sum{1,S,V:sudoku(X,Y,S,V)} != 9, S=(0..8).

% redefine for presentation
sudoku(X,Y,V) :- sudoku(X,Y,S,V).

#show sudoku/3.
