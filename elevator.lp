#include <incmode>.

#program base.
holds(at(elevator(X),Y),0) :- init(at(elevator(X),Y)).
holds(request(deliver(X),Y),0) :- init(request(deliver(X),Y)).
holds(request(call(X),Y),0) :- init(request(call(X),Y)).

#program step(t).
% create presence scene for movement
presenceD(elevator(X),-1,t-1) :- holds(at(elevator(X),Y),t-1), holds(request(deliver(X),Y'),t-1), Y'-Y < 0.
presenceD(elevator(X),1,t-1) :- holds(at(elevator(X),Y),t-1), holds(request(deliver(X),Y'),t-1), Y'-Y > 0.
presenceC(elevator(X),-1,t-1) :- holds(at(elevator(X),Y),t-1), holds(request(call(_),Y'),t-1), not holds(request(deliver(_),Y'),t), Y'-Y < 0.
presenceC(elevator(X),1,t-1) :- holds(at(elevator(X),Y),t-1), holds(request(call(_),Y'),t-1),  not holds(request(deliver(_),Y'),t), Y'-Y > 0.

% moving for delivery
{do(elevator(X),move(V),t): holds(at(elevator(X),Y),t-1), presenceD(elevator(X),V,t-1), not do(elevator(X),serve,t)}.

% moving for request
{do(elevator(X),move(V),t): holds(at(elevator(X),Y),t-1), presenceC(elevator(X),V,t-1), not do(elevator(X),serve,t)}.

% serving task
do(elevator(X),serve,t) :- holds(request(deliver(X),Y),t-1), holds(at(elevator(X),Y),t-1).
{do(elevator(X),serve,t): holds(request(call(_),Y),t-1), holds(at(elevator(X),Y),t-1), not deliveryServe(Y,t),not holds(request(deliver(_),Y),t-1)}.
deliveryServe(Y,t) :- holds(request(deliver(X),Y),t-1), holds(at(elevator(X),Y),t-1).
serving(Y,t) :- do(elevator(X),serve,t), holds(at(elevator(X),Y),t-1).

% transferring tasks and positions
holds(at(elevator(X),Y+V),t) :- holds(at(elevator(X),Y),t-1), do(elevator(X),move(V),t).
holds(at(elevator(X),Y),t) :- holds(at(elevator(X),Y),t-1), do(elevator(X),serve,t).
holds(at(elevator(X),Y),t) :- holds(at(elevator(X),Y),t-1), not do(elevator(X),_,t).
holds(request(call(V),Y),t) :- not serving(Y,t), holds(request(call(V),Y),t-1).
holds(request(deliver(X),Y),t) :- not holds(at(elevator(X),Y),t-1), holds(request(deliver(X),Y),t-1).

% constraint: ensure only one move per elevator per time step
:- do(elevator(X),A,t), do(elevator(X),A',t), A != A'.

% constraints: ensure logical movements
:- do(elevator(X),move(V),t-1), do(elevator(X),move(V'),t), V*V'=-1, t > 1.
:- do(elevator(X),move(V),t-2), holds(at(elevator(X),Y),t-2), do(elevator(X),serve,t-1), do(elevator(X), move(V'),t), holds(at(elevator(X),Y''),t), holds(request(deliver(X),Y'),t), V*V'=-1, |Y'-Y| < |Y'-Y''|, t > 3.

% optimize for moves
#minimize{1,X,V,T:do(elevator(X),move(V),T)}.

% print
#show do(A,X,t) : do(A,X,t).

#program check(t).
% check for success
:- query(t), holds(request(A,B),t).

% print
#show holds(X,t) : holds(X,t).
