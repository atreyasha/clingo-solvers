% Atreya Shankar
% shankar@uni-potsdam.de

#include <incmode>.

#program base.
move(1).
move(-1).
holds(at(elevator(X),Y),0) :- init(at(elevator(X),Y)).
holds(request(deliver(X),Y),0) :- init(request(deliver(X),Y)).
holds(request(call(X),Y),0) :- init(request(call(X),Y)).

#program step(t).

% moving for delivery
{do(elevator(X),move(V),t): holds(at(elevator(X),Y),t-1), holds(request(deliver(X),Y'),t), move(V), |Y+V-Y'|<|Y-Y'|, not do(elevator(X),serve,t)} <= N :- N = #sum{1,X:holds(request(deliver(X),Y'),t), not do(elevator(X),serve,t)}.

% moving for request
{do(elevator(X),move(V),t): holds(at(elevator(X),Y),t-1), holds(request(call(_),Y'),t), not holds(request(deliver(_),Y'),t), move(V), |Y+V-Y'|<|Y-Y'|, not do(elevator(X),serve,t)} <= N :- N = #min{A;B}, A = #sum{1,Y:holds(request(call(_),Y),t), not holds(request(deliver(_),Y),t)}, B = #sum{1,X:holds(at(elevator(X),_),t-1), not do(elevator(X),serve,t)}.

% define new elevator position
holds(at(elevator(X),Y+V),t) :- holds(at(elevator(X),Y),t-1), do(elevator(X),move(V),t).
holds(at(elevator(X),Y),t) :- holds(at(elevator(X),Y),t-1), do(elevator(X),serve,t).

% serving task
do(elevator(X),serve,t) :- holds(request(deliver(X),Y),t-1), holds(at(elevator(X),Y),t-1).
deliveryServe(Y,t) :- holds(request(deliver(X),Y),t-1), holds(at(elevator(X),Y),t-1).
{do(elevator(X),serve,t): holds(request(call(_),Y),t-1), holds(at(elevator(X),Y),t-1), not deliveryServe(Y,t), not holds(request(deliver(_),Y),t-1)} <= N :- N = #sum{1,Y:holds(request(call(_),Y),t-1), holds(at(elevator(_),Y),t-1), not deliveryServe(Y,t), not holds(request(deliver(_),Y),t-1)}.
serving(Y,t) :- do(elevator(X),serve,t), holds(at(elevator(X),Y),t-1).

% transferring tasks
holds(request(call(V),Y),t) :- not serving(Y,t), holds(request(call(V),Y),t-1).
holds(request(deliver(X),Y),t) :- not holds(at(elevator(X),Y),t-1), holds(request(deliver(X),Y),t-1).

% constraint: ensure only one move per elevator per time step
:- #sum{1,X,Y:do(elevator(X),Y,t)} != N, N = #sum{1,X:do(elevator(X),_,t)}.

% constraints: ensure logical movements
:- do(elevator(X),move(V),t-1), do(elevator(X),move(V'),t), V*V'=-1, t > 1.
:- not do(elevator(X),_,t-1), do(elevator(X),move(V),t), t > 1.
:- not do(elevator(X),_,t-1), do(elevator(X),serve,t), t > 1.
:- do(elevator(X),move(_),t-1), not do(elevator(X),move(_),t), not do(elevator(X),serve,t), t > 1.
:- not do(elevator(X),_,t), holds(request(deliver(X),_),t).
:- not do(elevator(X),_,t-1), holds(request(deliver(X),_),t), t > 1.
:- not do(elevator(X),_,t), holds(request(deliver(X),_),t+1), t > 1.
:- #sum{1,X:do(elevator(X),_,t)} = 0, #sum{1,A:holds(request(A),t)} != 0.
:- #sum{1,X:do(elevator(X),_,t-1)} = 0, #sum{1,A:holds(request(A),t)} != 0, t > 1.

% print
#show do(A,X,t) : do(A,X,t).

#program check(t).
% check for success
:- query(t), #max{A;B} != 0, A = #sum{1,X:holds(request(call(X),_),t)}, B = #sum{1,Y:holds(request(deliver(Y),_),t)}.

% optimize for moves
#minimize{1,X,T:do(elevator(X),_,T)}.

% print
#show holds(X,t) : holds(X,t).

% comments:
% slow solution due to too many choice rule sets
% try to process slow cases step by step to check for bottleneck
% improve constratints on logical movements to reduce model expansion
