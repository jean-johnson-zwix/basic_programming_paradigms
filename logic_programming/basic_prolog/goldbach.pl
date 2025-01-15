prime_in_range(N, N, [N]):-is_prime(N).
prime_in_range(N, N, []):- \+is_prime(N).
prime_in_range(N1, N2, [N1|Lt]) :- 
    N1<N2, N3 is N1+1,
    is_prime(N1),
    prime_in_range(N3, N2, Lt).
prime_in_range(N1, N2, L) :- 
    N1<N2, N3 is N1+1,
    prime_in_range(N3, N2, L).


is_prime_helper(2, []).
is_prime_helper(X, [X1|T]) :- 
    X>2, X1 is X-1, 
    is_prime_helper(X1, T).
is_prime(X) :- 
    X > 1, is_prime_helper(X, L), 
    \+ (member(F1, L), member(F2, L),
	X =:= F1*F2).

goldbach(Num,L):-
    prime_in_range(2,Num,PrimeNumbers),
    goldbach(Num,PrimeNumbers,L).
goldbach(Num,[Prime1|T],[Prime1,Prime2]):-
    Prime2 is Num - Prime1,
    member(Prime2,[Prime1|T]).
goldbach(Num,[Prime1|T],R):-
    N is Num - Prime1,
    \+member(N,[Prime1|T]),
    goldbach(Num,T,R).