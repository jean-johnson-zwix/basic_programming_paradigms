word(1):-write('one').
word(2):-write('two').
word(3):-write('three').
word(4):-write('four').
word(5):-write('five').
word(6):-write('six').
word(7):-write('seven').
word(8):-write('eight').
word(9):-write('nine').
word(0):-write('zero').

full_words(Num):-
    atom_length(Num,Len),
    L is Len - 1,
    LastDigit is Num mod 10,
    RemainingNum is Num//10,
    full_words(RemainingNum,L),
    word(LastDigit).
full_words(_,0). % terminating condition
full_words(Num,Len):-
    Len>0,
    L is Len - 1,
    LastDigit is Num mod 10,
    RemainingNum is Num//10,
    full_words(RemainingNum, L),
    word(LastDigit),write('-').
