% Tower of Hanoi

hanoi(1,From,To,_Middle):-
    write('Move '), write(From),write(' to '),write(To),nl.
hanoi(X,From,To,Middle):-
    X > 1,
    X1 is X-1,
    hanoi(X1,From,Middle,To),
    write('Move '), write(From),write(' to '),write(To),nl,
    hanoi(X1,Middle,To,From).