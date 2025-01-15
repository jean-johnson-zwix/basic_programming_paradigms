edge(a,b,1).
edge(a,c,6).
edge(b,c,4).
edge(b,e,1).
edge(b,d,3).
edge(c,d,1).
edge(d,e,1).

connected(From,To,Weight):-edge(From,To,Weight).
connected(From,To,Weight):-edge(To,From,Weight).

findpath(From,To,Weight,Path):-
    findpath(From,To,Weight,[From],Path).
findpath(From,To,Weight,SSF,Path):-
    connected(From,To,Weight),
    reverse([To|SSF],Path).
findpath(From,To,Weight,SSF,Path):-
    From\=To,
    connected(From,PathNode,W1),
    \+member(PathNode,SSF),
    findpath(PathNode,To,W2,[PathNode|SSF],Path),
    Weight is W1+W2.