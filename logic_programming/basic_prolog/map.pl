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

adjacent(Region1,Region2):-edge(Region1,Region2).
adjacent(Region1,Region2):-edge(Region2,Region1).

conflict([Region1,Color],[Region2,Color]):-
       adjacent(Region1,Region2).
safe(_,[]).
safe( H, [H2|T3] ) :-
    \+conflict(H,H2),safe(H,T3).

color_map(L):-
    regionList(RegionList),
    color_map(RegionList,L).
color_map([],[]).
color_map([Region|RegionList], [[Region,Color]|T]) :-
    color_map(RegionList,T),
    color(Color),
    safe([Region, Color],T).