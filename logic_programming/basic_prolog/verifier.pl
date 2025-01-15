setup :- (exists_file('findpath.pl') -> consult(findpath) ; write('\n***** Missing findpath.pl *****\n\n')),
    (exists_file('hanoi.pl') -> consult(hanoi) ; write('\n***** Missing hanoi.pl *****\n\n')),
    (exists_file('fullWords.pl') -> consult(fullWords) ; write('\n***** Missing fullWords.pl *****\n\n')),
    (exists_file('combination.pl') -> consult(combination) ; write('\n***** Missing combination.pl *****\n\n')),
    (exists_file('map.pl') -> consult(map) ; write('\n***** Missing map.pl *****\n\n')),
    (exists_file('nQueens.pl') -> consult(nQueens) ; write('\n***** Missing nQueens.pl *****\n\n')),
    (exists_file('goldbach.pl') -> consult(goldbach) ; write('\n***** Missing goldbach.pl *****\n\n')).

check(Template, Goal) :- findall(Template, Goal, L), write(Goal), write(': '), portray_clause(L), nl, nl.

%%%%%%%%%%%%%%%%%%%%%%%%%
%   findpath edges
%%%%%%%%%%%%%%%%%%%%%%%%%
edge(a,b,1).
edge(a,c,6).
edge(b,c,4).
edge(b,e,1).
edge(b,d,3).
edge(c,d,1).
edge(d,e,1).

%%%%%%%%%%%%%%%%%%%%%%%%%
%   Map for Map coloring
%%%%%%%%%%%%%%%%%%%%%%%%%
% define list containing the regions
regionList([1,2,3,4,5,6]).

% color facts to define the four colors
color(red).
color(green).
color(blue).
color(yellow).

% define the edges between regions
edge(1,2).
edge(1,3).
edge(1,4).
edge(1,6).
edge(2,3).
edge(2,5).
edge(3,4).
edge(3,5).
edge(3,6).
edge(4,5).
edge(4,6).

run :- setup,
    (current_predicate(findpath/4) -> check((W,P), findpath(a,d,W,P)) ; write('\n***** Missing findpath/4 *****\n\n')),
    write('hanoi: '),
    (current_predicate(hanoi/4) -> (hanoi(3, a, c, b)) ; write('\n***** Missing hanoi/4 *****\n\n')),
    write('full_words: '),
    (current_predicate(full_words/1) -> (full_words(283)) ; write('\n***** Missing full_words/1 *****\n\n')),
    (current_predicate(combination/3) -> check((L), combination(3,[a,b,c,d,e,f],L)) ; write('\n***** Missing combination/3 *****\n\n')),
    (current_predicate(color_map/1) -> check((L), color_map(L)) ; write('\n***** Missing color_map/1 *****\n\n')),
    (current_predicate(queens/2) -> check((Qs), queens(6, Qs)) ; write('\n***** Missing queens/2 *****\n\n')),
    (current_predicate(goldbach/2) -> check((L), goldbach(28, L)) ; write('\n***** Missing goldbach/2 *****\n\n')),
    halt.