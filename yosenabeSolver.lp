% create targets and traces
{target(X,Y,X,Y',I,V): number(X,Y,V), area(X,Y',I)}.
{target(X,Y,X',Y,I,V): number(X,Y,V), area(X',Y,I)}.
trace(X..X',Y..Y',X,Y) :- target(X,Y,X',Y',_,_).
trace(X'..X,Y..Y',X,Y) :- target(X,Y,X',Y',_,_).
trace(X..X',Y'..Y,X,Y) :- target(X,Y,X',Y',_,_).
trace(X'..X,Y'..Y,X,Y) :- target(X,Y,X',Y',_,_).

% simplest constraints here to remove duplicates and overlapping
:-#sum{1,X,Y:target(X,Y,_,_,_,_)} != N, N = #sum{1,A,B:number(A,B,_)}.
:-#sum{1,X',Y':target(_,_,X',Y',_,_)} != N, N = #sum{1,A,B:number(A,B,_)}.
:-#sum{1,X,Y,X',Y':target(X,Y,X',Y',_,_)} != N, N = #sum{1,A,B:number(A,B,_)}.

% constraints to ensure all shaded areas are filled up
:-#sum{1,I:target(_,_,_,_,I,_)} != N, N = #sum{1,C:area(_,_,C)}.

% complex constraints to prevent crossing by traces
:- trace(X,Y,X',_), trace(X,Y,X'',_), X''!= X'.
:- trace(X,Y,_,Y'), trace(X,Y,_,Y''), Y''!= Y'.

% constraints to ensure goal matching
:-#sum{V,I,X,Y:target(X,Y,_,_,I,V)} != G, G = #sum{V,I:goal(I,V)}, goal(I,_).

% project and print
target(X,Y,X',Y') :- target(X,Y,X',Y',I,V).
#show target/4.
