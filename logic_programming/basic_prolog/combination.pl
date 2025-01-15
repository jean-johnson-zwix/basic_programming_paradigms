combination(0, _, []).
combination(N, L, [L1h|L1t]) :- N > 0, extract_member(L1h, L, L2), N1 is N-1, combination(N1, L2, L1t).
extract_member(X, [X|Lt], Lt).
extract_member(X, [_|Lt], L1) :- extract_member(X, Lt, L1).