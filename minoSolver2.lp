% activate incremental mode
#include <incmode>.

#program base.
% define move space, stationary, vertical, horizontal
move(1,0,1,0). move(-1,0,2,0).
move(0,-1,3,0). move(0,1,4,0).
move(0,0,5,0).
move(0,0,5,1).

% define player base `aat`
aat(X,Y,0) :- start(X,Y).
at(X,Y,0) :- aat(X,Y,0).

% define mino base `aat`
mmino(X,Y,0) :- mino(X,Y).

#program step(t).
% creaate possible movement space for user based on free will and wall
{aat(X+X',Y+Y',t): move(X',Y',_,(t-1)\2), field(X+X',Y+Y'), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), not mmino(X+X',Y+Y',t)} = 1 :- aat(X,Y,t-1), t <= 2*N,maxsteps(N).

% define actions for mino
action(t-1,1) :- mmino(X,Y,t-1), aat(XX,YY,t), X-XX < 0, move(X',Y',1,_), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), field(X+X',Y+Y').
action(t-1,2) :- mmino(X,Y,t-1), aat(XX,YY,t), X-XX > 0, move(X',Y',2,_), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), field(X+X',Y+Y').
action(t-1,3) :- mmino(X,Y,t-1), aat(XX,YY,t), Y-YY > 0, not action(t-1,1), not action(t-1,2), move(X',Y',3,_), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), field(X+X',Y+Y').
action(t-1,4) :- mmino(X,Y,t-1), aat(XX,YY,t), Y-YY < 0, not action(t-1,1), not action(t-1,2) , move(X',Y',4,_), not wall(X,Y,X+X',Y+Y'), not wall(X+X',Y+Y',X,Y), field(X+X',Y+Y').
action(t-1,5) :- mmino(X,Y,t-1), aat(XX,YY,t), move(X',Y',5,_), not action(t-1,1), not action(t-1,2), not action(t-1,3), not action(t-1,4).

% generate deterministic movement for mino
{mmino(X+X',Y+Y',t): move(X',Y',V,_), action(t-1,V)} = 1 :- mmino(X,Y,t-1).

% remove bad cases
:- aat(X,Y,t), mmino(X,Y,t).

% create success variable
success(X,Y,t) :- goal(X,Y), aat(X,Y,t), not mmino(X,Y,t), t\2 = 0.

% reproject onto relevant time scale
at(X,Y,S) :- aat(X,Y,t), t = 2*S.

#program check(t).
% keep cases which end with goal
:- query(t), goal(X,Y), not success(X,Y,t).

#show at/3.
