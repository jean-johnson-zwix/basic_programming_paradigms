generate_rows(0,[]).
generate_rows(N,[N|T]):-
    N>0, N1 is N-1,
    generate_rows(N1,T).

safe(_,[],_).
safe(Row,[H|T],Diff):-
    Row =\= H,
    AbsDiff is abs(Row - H),
    Diff =\= AbsDiff,
    NextDiff = Diff + 1,
    safe(Row,T,NextDiff).

queens(N,Result):-
    generate_rows(N,AvailableRows),queens(AvailableRows,[],Result).
queens([],Result,Result).
queens(AvailableRows,SSF,Result):-
    select(Row,AvailableRows,RemainingRows),
    safe(Row,SSF,1),
    queens(RemainingRows,[Row|SSF],Result).
