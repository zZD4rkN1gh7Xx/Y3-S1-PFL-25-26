:- use_module(library(lists)).

%------ AUXILIAR FUNCTIONS ------

consecutive(X,Y,Board) :-
	append(_,[X,Y|_], Board).

space_between(X,Y,Board) :-
	append(_, [X,_,Y|_], Board).

across_board(X,Y,Board) :-
	nth1(PositionX, Board, X),
	nth1(PositionY, Board, Y),
	member(PositionX, [1,2]),
	member(PositionY, [4,5,6]).

common_edge(X,Y,Board) :-
	nth1(PositionX, Board, X),
	nth1(PositionY, Board, Y),
	member(PositionX, [1,2]),
	member(PositionY, [1,2]).
common_edge(X,Y,Board) :-
	nth1(PositionX, Board, X),
	nth1(PositionY, Board, Y),
	member(PositionX, [4,5,6]),
	member(PositionY, [4,5,6]).

position_board(X,L,Board) :-
	nth1(PositionX, Board, X),
	member(PositionX,L).


%------ CONSTRAIN FUNCTIONS ------

anywhere(X, Board) :-
	member(X,Board).

next_to(X,X,_).
next_to(X,Y, Board) :-
	consecutive(X, Y, Board).
next_to(X,Y,Board) :-
	consecutive(Y, X, Board).

one_space(X, X, _).
one_space(X, Y, Board) :-
	space_between(X,Y,Board).
one_space(X, Y, Board) :-
	space_between(Y,X,Board).

across(X,X,_).
across(X, Y, Board) :-
	across_board(X,Y,Board).
across(X,Y,Board) :-
	across_board(Y,X,Board).

same_edge(X,X,_).
same_edge(X, Y, Board):-
	common_edge(X,Y,Board).

position(X, L, Board) :-
	position_board(X,L,Board).



%------ SOLVER FUNCTION--------
%solve(+Constraints, -Board)
solve(Constraints, Board) :-
	permutation([green, yellow, blue, orange, white, black], Board),
    check_constraints(Constraints, Board).

check_constraints([], _).
check_constraints([C|Rest], Board) :-
    call(C, Board),
    check_constraints(Rest, Board).


%best_score(+Constraints, -Score) 
best_score(Constraints, BestScore) :-
    permutation([green, yellow, blue, orange, white, black], Board),
    count_violations(Constraints, Board, Violations),
    BestScore is -Violations,
    \+ (better_score_exists(Constraints, BestScore)), !.

better_score_exists(Constraints, CurrentScore) :-
    permutation([green, yellow, blue, orange, white, black], Board),
    count_violations(Constraints, Board, Violations),
    Score is -Violations,
    Score > CurrentScore.

count_violations([], _, 0).
count_violations([C|Rest], Board, Count) :-
    call(C, Board),
    count_violations(Rest, Board, Count).
count_violations([C|Rest], Board, Count) :-
    \+ call(C, Board),
    count_violations(Rest, Board, RestCount),
    Count is RestCount + 1.













%------ EXAMPLES--------
%% 12 solutions
example(1, [ next_to(white,orange),
next_to(black,black),
across(yellow,orange),
next_to(green,yellow),
position(blue,[1,2,6]),
across(yellow,blue) ]).
%% 1 solution
example(2, [ across(white,yellow),
position(black,[1,4]),
position(yellow,[1,5]),
next_to(green, blue),
same_edge(blue,yellow),
one_space(orange,black) ]).
%% no solutions (5 constraints are satisfiable)
example(3, [ across(white,yellow),
position(black,[1,4]),
position(yellow,[1,5]),
same_edge(green, black),
same_edge(blue,yellow),
one_space(orange,black) ]).
%% same as above, different order of constraints
example(4, [ position(yellow,[1,5]),
one_space(orange,black),
same_edge(green, black),
same_edge(blue,yellow),
position(black,[1,4]),
across(white,yellow) ]).
