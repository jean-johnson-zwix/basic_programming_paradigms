:-use_module(library(clpfd)).
%:- use_rendering(chess).

% Q1. N QUEENS PROBLEM

queens(N,Qs) :-
    length(Qs,N),
    Qs ins 1..N,
    all_distinct(Qs),
    diagC(Qs),
    labeling([ffc],Qs).

diagC([]).
diagC([Q1|Qs]) :- 
    checkDiagonalConstraint(Q1,Qs,1), 
    diagC(Qs).

checkDiagonalConstraint(_,[],_).
checkDiagonalConstraint(Queen,[Q1|Qs],D):-
    abs(Queen-Q1) #\= D,
    D1#=D+1,
    checkDiagonalConstraint(Queen,Qs,D1).

% Q2. SUDOKU SOLVER

problem(1,
    [[_,_,6, 5,9,_, _,_,_],
	[_,_,3, _,_,_, _,7,_],
	[_,_,_, _,_,_, 5,6,_],
	[_,2,_, 1,7,_, _,_,_],
	[4,8,5, _,_,_, _,_,_],
	[_,6,_, _,_,4, 9,_,_],
	[2,_,_, _,_,5, _,_,8],
	[_,3,8, _,_,1, _,_,_],
	[_,_,_, 3,_,_, 7,5,4]]).

addAllDifferentConstraint([]).
addAllDifferentConstraint([R|Rs]):- 
    R ins 1..9, all_different(R),
	addAllDifferentConstraint(Rs).

setBlocks([],[],[]).
setBlocks([N1,N2,N3|R1],[N4,N5,N6|R2],[N7,N8,N9|R3]):-
    all_different([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
    setBlocks(R1,R2,R3).

sudoku(Rows):-
	addAllDifferentConstraint(Rows),
	transpose(Rows,Columns), % create list of columns.
	addAllDifferentConstraint(Columns),
    Rows = [Row1, Row2, Row3, Row4, Row5, Row6, Row7, Row8, Row9],
    % constraint for 3X3 box
    setBlocks(Row1,Row2,Row3),
    setBlocks(Row4,Row5,Row6),
    setBlocks(Row7,Row8,Row9),
	flatten(Rows,R), labeling([ffc], R).
	
% Q3. ZEBRA PUZZLE

solveZebra(Zebra,Water):-
    
    % initialization
	Colors = [Red,Green,White,Yellow,Blue],
    Colors ins 1..5,
    all_different(Colors),
	Nationality = [English,Spanish,Ukrainian,Norwegian,Japanese],
    Nationality ins 1..5,
    all_different(Nationality),
    Pets = [Dog,Serpent,Fox,Horse,Zebra],
    Pets ins 1..5,
    all_different(Pets),
    Smokes = [Winston,Kool,Chesterfield,LuckyStrike,Kent],
    Smokes ins 1..5,
    all_different(Smokes),
    Drinks = [Tea,Milk,Juice,Water,Coffee],
	Drinks ins 1..5,
    all_different(Drinks),
	
    % constraints
    English #= Red,
    Spanish #= Dog,
    Green #= Coffee,
    Ukrainian #= Tea,
    abs(Green-White) #= 1,
    Winston #= Serpent,
    Yellow #= Kool,
    Milk #= 3,
    Norwegian #= 1,
    abs(Chesterfield-Fox) #= 1,
    abs(Horse-Kool) #= 1,
    LuckyStrike #= Juice,
    Japanese #= Kent,
    abs(Norwegian-Blue) #= 1, 
    
    flatten([Colors,Nationality,Pets,Smokes,Drinks],Result), 
    labeling([ffc], Result).

% Q4. MAP COLORING

% regions
regionList([1,2,3,4,5,6]).
% colors
colorList([1,2,3,4]).
color(1,red).
color(2,green).
color(3,blue).
color(4,yellow).
% edges
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
% map
map(RegionList,ColorList):-
    regionList(RegionList),colorList(ColorList).

adjacent(Region1,Region2):-edge(Region1,Region2).
adjacent(Region1,Region2):-edge(Region2,Region1).

safe([_,_],[],[]).
safe([R1,C1],[C2|MapColorList],[R2|RegionList]):-
    adjacent(R1,R2), C1 #\= C2,
    safe([R1,C1],MapColorList,RegionList).
safe([R1,C1],[_|MapColorList],[R2|RegionList]):-
    \+adjacent(R1,R2), 
	safe([R1,C1],MapColorList,RegionList).

assignAdjacentConstraint([],[]).
assignAdjacentConstraint([C1|MapColorList],[R1|RegionList]):-
    safe([R1,C1],MapColorList,RegionList),
    assignAdjacentConstraint(MapColorList,RegionList).


generate_output([C|[]],[R|[]],[[R,Color]]):-
    color(C,Color).
generate_output([C|T1],[R|T2],[[R,Color]|T3]):-
    color(C,Color),
    generate_output(T1,T2,T3).

color_map(Result):-
    % initialization
    map(Regions,Colors),
    length(Regions,RegionCount), 
    length(MapColorList,RegionCount),
    length(Colors,ColorCount),
    MapColorList ins 1..ColorCount,
    % constraints
    assignAdjacentConstraint(MapColorList,Regions),
    labeling([ffc], MapColorList),
    generate_output(MapColorList,Regions,Result).