p(program(X)) --> k(X),['.'].
k(block(X,Y)) --> [begin],d(X),[;],c(Y),[end].

% declaration
d(declaration(X,Y)) --> d1(X),[;],d(Y).
d(declare(X)) --> d1(X).
d1(const(X,Y)) --> [const],i(X),[=],n(Y).
d1(var(X)) --> [var],i(X).

% command
c(command_block(X,Y)) --> c1(X),[;],c(Y).
c(command(X)) --> c1(X).
c1(:=(X,Y)) --> i(X),[':='],e(Y).
c1(if_then_else(X,Y,Z)) --> [if],b(X),[then],c(Y),[else],c(Z),[endif].
c1(while_do(X,Y)) --> [while],b(X),[do],c(Y),[endwhile].
c1(command(X)) --> k(X).

% boolean expressions
b(not(X)) --> [not],b(X).
b(=(X,Y)) --> val(X),[=],e(Y).
b(b(true)) --> [true].
b(b(false)) --> [false].

% expressions
e(+(X,Y)) --> val(X),[+],term(Y).
e(*(X,Y)) --> val(X),[*],term(Y).
e(-(X,Y)) --> val(X),[-],term(Y).
e(/(X,Y)) --> val(X),[/],term(Y).
e(expr(X)) --> val(X).	
term(term(X)) --> e(X).

% value could be number/identifiers
val(value(X)) -->n(X)|i(X).

% numbers
n(number(0)) --> [0].
n(number(1)) --> [1].
n(number(2)) --> [2].
n(number(3)) --> [3].
n(number(4)) --> [4].
n(number(5)) --> [5].
n(number(6)) --> [6].
n(number(7)) --> [7].
n(number(8)) --> [8].
n(number(9)) --> [9].

% identifiers 
i(identifier(x)) --> [x].
i(identifier(y)) --> [y].
i(identifier(z)) --> [z].
i(identifier(u)) --> [u].
i(identifier(v)) --> [v].
