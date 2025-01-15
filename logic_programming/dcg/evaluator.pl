:- table expr/3, term/3, command/3,expr_eval/4.

% EVALUATOR 

% Environment look up -> lookup(Env,Id,Value).
lookup([[Id,Value]|_],Id,Value).
lookup([[H,_]|T],Id,Value):- H\=Id, lookup(T,Id,Value).
lookup([],_,_):-write('Runtime Error').
    
% Environment update -> update(Env,Id,Value,NewEnv).
update([],1,-1,[]).
update([],Id,Value,[[Id,Value]]):- Id\=1.
update([[X,V]|T],Id,Value,[[X,V]|R]):-
    X\=Id, update(T,Id,Value,R).
update([[Id,_]|T],Id,Value,[[Id,Value]|R])
	:- update(T,1,-1,R).


% evaluate program
program_eval(program(Block),X,Y,Z):-
    block_eval(Block,[],X,Y,Z).

% evaluate block
block_eval(block(DeclarationBlock,CommandBlock),Env,X,Y,Z):-
    declaration_eval(DeclarationBlock,Env,NewEnv1),
    update(NewEnv1,'x',X,NewEnv2),update(NewEnv2,'y',Y,NewEnv3),
    command_eval(CommandBlock,NewEnv3,NewEnv4),
    lookup(NewEnv4,'z',Z).

% evaluate declaration
declaration_eval(id(X),Env,NewEnv):-update(Env,X,0,NewEnv).
declaration_eval(X=Y,Env,NewEnv):-update(Env,X,Y,NewEnv).
declaration_eval(declare(X,Y),Env,NewEnv2):-
    declaration_eval(X,Env,NewEnv1),
    declaration_eval(Y,NewEnv1,NewEnv2).


% evaluate commands
command_eval(command(Command1,Command2),Env,NewEnv2):-
    command_eval(Command1, Env, NewEnv1),
    command_eval(Command2, NewEnv1, NewEnv2).
command_eval(X=Expr,Env,NewEnv2):-
    expr_eval(Env,Expr,Value,NewEnv1),
    update(NewEnv1,X,Value,NewEnv2).

% evaluate conditional commands
command_eval(if(condition(BoolExpr),then(Command1),else(_)), Env, NewEnv2):-
    boolean_expr_eval(BoolExpr,Env,NewEnv1,true),
    command_eval(Command1,NewEnv1,NewEnv2).
command_eval(if(condition(BoolExpr),then(_),else(Command2)), Env, NewEnv2):-
    boolean_expr_eval(BoolExpr,Env,NewEnv1,false),
    command_eval(Command2,NewEnv1,NewEnv2).

%evaluate loop commands
command_eval(LoopStatement, Env, NewEnv3):-
    LoopStatement=while(condition(BoolExpr),loop_body(Command)),
    boolean_expr_eval(BoolExpr,Env,NewEnv1,true),
    command_eval(Command,NewEnv1,NewEnv2),
    command_eval(LoopStatement,NewEnv2,NewEnv3).

command_eval(LoopStatement, Env, NewEnv1):-
    LoopStatement=while(condition(BoolExpr),loop_body(_)),
    boolean_expr_eval(BoolExpr,Env,NewEnv1,false).

% evaluate boolean expression
boolean_expr_eval(Expr1=Expr2,Env,NewEnv2,true):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1=Value2.
boolean_expr_eval(Expr1=Expr2,Env,NewEnv2,false):-
    expr_eval(Env,Expr1,Value1,NewEnv1),
    expr_eval(NewEnv1,Expr2,Value2,NewEnv2),
    Value1\=Value2.
boolean_expr_eval(not(Expr),Env,NewEnv,false):-
    boolean_expr_eval(Expr, Env, NewEnv,true).
boolean_expr_eval(not(Expr),Env,NewEnv,true):-
    boolean_expr_eval(Expr, Env, NewEnv,false).

% evaluate expression
expr_eval(Env,Val,Value,Env):-
    val_eval(Env,Val,Value).
expr_eval(Env,X+Y,Value,NewEnv2):-
    expr_eval(Env,X,X_Value,NewEnv1),expr_eval(NewEnv1,Y,Y_Value,NewEnv2),
    Value is X_Value+Y_Value.
expr_eval(Env,X-Y,Value,NewEnv2):-
    expr_eval(Env,X,X_Value,NewEnv1),expr_eval(NewEnv1,Y,Y_Value,NewEnv2),
    Value is X_Value-Y_Value.
expr_eval(Env,X*Y,Value,NewEnv2):-
    expr_eval(Env,X,X_Value,NewEnv1),expr_eval(NewEnv1,Y,Y_Value,NewEnv2),
    Value is X_Value*Y_Value.
expr_eval(Env,X/Y,Value,NewEnv2):-
    expr_eval(Env,X,X_Value,NewEnv1),expr_eval(NewEnv1,Y,Y_Value,NewEnv2),
    Value is X_Value/Y_Value.
expr_eval(Env,(Expr),Value,NewEnv):-
    expr_eval(Env,Expr,Value,NewEnv).
expr_eval(Env,X=Expr,Value,NewEnv2):-
    expr_eval(Env,Expr,Value,NewEnv1),
    update(NewEnv1,X,Value,NewEnv2).


% evaluate values
val_eval(_,Id,Id):-number(Id).
val_eval(Env,Id,Value):- 
    atom(Id), member(Id,[x,y,z,u,v]), lookup(Env,Id,Value).

% DCG PROGRAM

% program
program(program(X)) --> block(X),[.].

% Block
block(block(X,Y))-->[begin],declaration(X),[;],command(Y),[end].

% Declarations
declaration(declare(assign(X,Y),Z))-->[const],id(X),[=],num(Y),[;],declaration(Z).
declaration(declare(id(X),Y))-->[var],id(X),[;],declaration(Y).
declaration(=(X,Y))-->[const],id(X),[=],num(Y).
declaration(id(X))-->[var],id(X).

% Commands
command(command(X,Y)) --> command(X),[;],command(Y).
command(=(X,Y)) --> id(X), [:=], expr(Y).
command(if(condition(X),then(Y),else(Z)))-->[if],bool_expr(X),
           [then],command(Y),[else],command(Z),[endif].
command(while(condition(X),loop_body(Y)))-->
    [while],bool_expr(X),[do],command(Y),[endwhile].
command(X)-->block(X).

% Boolean Expression
bool_expr(=(X,Y)) --> expr(X),['='],expr(Y).
bool_expr(not(X)) --> [not],bool_expr(X).
bool_expr(true) --> [true].
bool_expr(false) --> [false].

% Arithmetic Expressions
expr(=(X,Y)) --> id(X), [:=], expr(Y).
expr(+(X,Y)) --> expr(X), [+], term(Y).
expr(-(X,Y)) --> expr(X), [-], term(Y).
expr(X) --> term(X).
term(*(X,Y))--> term(X), [*], val(Y).
term(/(X,Y))--> term(X), [/], val(Y).
term(X)-->['('],expr(X),[')'].
term(X) --> val(X).
val(X) --> num(X).
val(X) --> id(X).

num(X) --> [X], {number(X)}.
id(I) --> [I], {atom(I), member(I,[x,y,z,u,v])}.

