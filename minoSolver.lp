% activate incremental mode
#include <incmode>.

#program base.
% define move space, stationary, vertical, horizontal
move(1,0,1). move(-1,0,2).
move(0,-1,3). move(0,1,4).
move(0,0,5).

% define player base `at`
at(X,Y,0) :- start(X,Y).

% define mino base `at`
mmino(X,Y,0) :- mino(X,Y).

#program step(t).
% create possible movement space for user based on free will and wall
{at(X+X',Y+Y',t): move(X',Y',_), field(X+X',Y+Y'), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), not mino(X+X',Y+Y',t)} = 1 :- at(X,Y,t-1), t <= N,maxsteps(N), not goal(X,Y).

% define actions for mino
action(S,1) :- mmino(X,Y,S), at(XX,YY,S/2+1), X-XX < 0, move(X',Y',1), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), field(X+X',Y+Y'), S < 2*t, S >= 2*(t-1).
action(S,2) :- mmino(X,Y,S), at(XX,YY,S/2+1), X-XX > 0, move(X',Y',2), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), field(X+X',Y+Y'), S < 2*t, S >= 2*(t-1).
action(S,3) :- mmino(X,Y,S), at(XX,YY,S/2+1), Y-YY > 0, not action(S,1), not action(S,2), move(X',Y',3), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), field(X+X',Y+Y'), S < 2*t, S >= 2*(t-1).
action(S,4) :- mmino(X,Y,S), at(XX,YY,S/2+1), Y-YY < 0, not action(S,1), not action(S,2) , move(X',Y',4), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), field(X+X',Y+Y'), S < 2*t, S >= 2*(t-1).
action(S,5) :- mmino(X,Y,S), at(XX,YY,S/2+1), move(X',Y',5), not action(S,1), not action(S,2), not action(S,3), not action(S,4), S < 2*t, S >= 2*(t-1).

% create deterministic movement for mino based on player move
{mmino(X+X',Y+Y',S+1): move(X',Y',V), action(S,V)} = 1 :- mmino(X,Y,S), S < 2*t, S >= 2*(t-1).

% project mino back to player timestep
mino(X,Y,t) :- mmino(X,Y,2*(t)), at(X',Y',t).

#program check(t).
% keep cases which end with goal
:- query(t), goal(X,Y), not at(X,Y,t).

#show at/3.
