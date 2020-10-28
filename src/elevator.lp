% initialize and create targets
move(1).
move(-1).
holds(A,0) :- init(A).
targets(elevator(X),Y') :- holds(at(elevator(X),Y),0), holds(request(deliver(X),Y'),0).
{targets(elevator(X),Y'): holds(at(elevator(X),_),0)} :- holds(request(call(_),Y'),0), not holds(request(deliver(_),Y'),0).

% constraints to ensure all tasks are targetted, and no double tasking
:- targets(elevator(X),Y), targets(elevator(X'),Y), X' != X, holds(request(call(_),Y),0), not holds(request(deliver(_),Y),0).
:- holds(request(_,Y),0), not targets(_,Y).

% calculate number of tasks per elevator
number(elevator(X),N) :- N = #sum{1,Y:targets(elevator(X),Y)}, holds(at(elevator(X),_),0).

% distribution parameter for elevator vs. requests, given multiple targets
param(elevator(X),M,N) :- holds(at(elevator(X),_),0), M = #max{Y-Y':holds(at(elevator(X),Y),0), targets(elevator(X),Y')}, N = #min{Y-Y':holds(at(elevator(X),Y),0), targets(elevator(X),Y')}, L > 1, number(elevator(X),L).

% action if only one target exists
target1(elevator(X),Y) :- targets(elevator(X),Y), N = 1, number(elevator(X),N).
target2(elevator(X),Y) :- target1(elevator(X),Y), N = 1, number(elevator(X),N).

% action if multiple targets exist, elevator inside target span
target1(elevator(X),Q) :- holds(at(elevator(X),Y),0), targets(elevator(X),Q), N = #min{|M|;|K|}, param(elevator(X),M,K), M*K <= 0, Q = Y+N, not target2(elevator(X), Q), L > 1, number(elevator(X),L), #false:targets(elevator(X),Q'), Q'>Q.
target1(elevator(X),Q) :- holds(at(elevator(X),Y),0), targets(elevator(X),Q), N = #min{|M|;|K|}, param(elevator(X),M,K), M*K <= 0, Q = Y-N, not target2(elevator(X), Q), L > 1, number(elevator(X),L), #false:targets(elevator(X),Q'), Q'<Q.
target2(elevator(X),Q) :- holds(at(elevator(X),Y),0), targets(elevator(X),Q), N = #max{|M|;|K|}, param(elevator(X),M,K), M*K <= 0, Q = Y+N, target1(elevator(X), Q''), Q''!= Q, L > 1, number(elevator(X),L), #false:targets(elevator(X),Q'), Q'>Q.
target2(elevator(X),Q) :- holds(at(elevator(X),Y),0), targets(elevator(X),Q), N = #max{|M|;|K|}, param(elevator(X),M,K), M*K <= 0, Q = Y-N, target1(elevator(X), Q''), Q''!= Q, L > 1, number(elevator(X),L), #false:targets(elevator(X),Q'), Q'<Q.

% action if multiple targets exist, elevator outside target span
target1(elevator(X),Q) :- holds(at(elevator(X),Y),0), targets(elevator(X),Q), N = #min{|M|;|K|}, param(elevator(X),M,K), M*K > 0, Q = Y+N, L > 1, number(elevator(X),L).
target1(elevator(X),Q) :- holds(at(elevator(X),Y),0), targets(elevator(X),Q), N = #min{|M|;|K|}, param(elevator(X),M,K), M*K > 0, Q = Y-N, L > 1, number(elevator(X),L).
target2(elevator(X),Q) :- holds(at(elevator(X),Y),0), targets(elevator(X),Q), N = #max{|M|;|K|}, param(elevator(X),M,K), M*K > 0, Q = Y+N, target1(elevator(X), Q''), Q''!= Q, L > 1, number(elevator(X),L), #false:targets(elevator(X),Q'), Q'>Q.
target2(elevator(X),Q) :- holds(at(elevator(X),Y),0), targets(elevator(X),Q), N = #max{|M|;|K|}, param(elevator(X),M,K), M*K > 0, Q = Y-N, target1(elevator(X), Q''), Q''!= Q, L > 1, number(elevator(X),L), #false:targets(elevator(X),Q'), Q'<Q.

% ensure only one target 1 and 2 exist
:- target1(elevator(X),_), not target2(elevator(X),_).
:- target2(elevator(X),_), not target1(elevator(X),_).
:- target1(elevator(X),Y), target1(elevator(X),Y'), Y!=Y'.
:- target2(elevator(X),Y), target2(elevator(X),Y'), Y!=Y'.

% calculate per-elevator and cumulative moves (deterministic)
moves(elevator(X),N) :- N = #sum{|Y-Y'|;|Y'-Y''|}, holds(at(elevator(X),Y),0), target1(elevator(X),Y'), target2(elevator(X),Y'').
allmoves(N) :- N = #sum{M:moves(elevator(_),M)}.

#include <incmode>.
#show.

#program base.
% pass

#program step(t).
% moving elevators based on target1 and target2
do(elevator(X),move(V),t) :- holds(at(elevator(X),Y),t-1), target1(elevator(X),Y'), holds(request(deliver(X),Y'),t), move(V), |Y+V-Y'|<|Y-Y'|, not do(elevator(X),serve,t).
do(elevator(X),move(V),t) :- holds(at(elevator(X),Y),t-1), target1(elevator(X),Y'), holds(request(call(_),Y'),t), move(V), |Y+V-Y'|<|Y-Y'|, not do(elevator(X),serve,t).
do(elevator(X),move(V),t) :- holds(at(elevator(X),Y),t-1), target2(elevator(X),Y'), holds(request(deliver(X),Y'),t), target1(elevator(X),Y''), not holds(request(deliver(X),Y''),t), not holds(request(call(_),Y''),t), move(V), |Y+V-Y'|<|Y-Y'|, not do(elevator(X),serve,t).
do(elevator(X),move(V),t) :- holds(at(elevator(X),Y),t-1), target2(elevator(X),Y'), holds(request(call(_),Y'),t), target1(elevator(X),Y''), not holds(request(deliver(X),Y''),t), not holds(request(call(_),Y''),t), move(V), |Y+V-Y'|<|Y-Y'|, not do(elevator(X),serve,t).

% serving task
do(elevator(X),serve,t) :- holds(request(deliver(X),Y),t-1), holds(at(elevator(X),Y),t-1), targets(elevator(X),Y).
do(elevator(X),serve,t) :- holds(request(call(_),Y),t-1), holds(at(elevator(X),Y),t-1), targets(elevator(X),Y).
serving(Y,t) :- do(elevator(X),serve,t), holds(at(elevator(X),Y),t-1).

% transferring tasks and positions
holds(at(elevator(X),Y+V),t) :- holds(at(elevator(X),Y),t-1), do(elevator(X),move(V),t).
holds(at(elevator(X),Y),t) :- holds(at(elevator(X),Y),t-1), do(elevator(X),serve,t).
holds(at(elevator(X),Y),t) :- holds(at(elevator(X),Y),t-1), not do(elevator(X),_,t).
holds(request(call(V),Y),t) :- not serving(Y,t), holds(request(call(V),Y),t-1).
holds(request(deliver(X),Y),t) :- not holds(at(elevator(X),Y),t-1), holds(request(deliver(X),Y),t-1).

% optimize for moves
#minimize{N:allmoves(N)}.

% print
#show do(A,X,t) : do(A,X,t).

#program check(t).
% check for success
:- query(t), holds(request(A,B),t).

% print
#show holds(X,t) : holds(X,t).
