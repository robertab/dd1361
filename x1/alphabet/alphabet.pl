[kattio].

main :-
    repeat,
    read_string(S),
    (S == end_of_file ;
     string_length(S, L), string_codes(S, Ss),
     countWhiteSpace(L, Ss), countLowerCase(L, Ss),
     countUpperCase(L, Ss), countSymbol(L, Ss),
     fail
    ).

countWhiteSpace([], 0) :- !.
countWhiteSpace(95, 1) :- !.
countWhiteSpace([H | T], Z) :-
    countWhiteSpace(H, Z1),
    countWhiteSpace(T, Z2),
    Z is Z1 + Z2, !.
countWhiteSpace(_, 0) :- !.

countWhiteSpace(L, Ss) :-
    countWhiteSpace(Ss, N),
    Z is N/L,
    write(Z), nl, !.

countUpperCase([], 0) :- !.
countUpperCase([S|T], N) :-
    countUpperCase(S, N1),
    countUpperCase(T, N2),
    N is N1 + N2, !.
countUpperCase(S, 1) :- code_type(S, upper).
countUpperCase(_, 0).

countUpperCase(L, Ss) :-
    countUpperCase(Ss, N),
    Z is N / L,
    write(Z), nl, !.

countLowerCase([], 0) :- !.
countLowerCase([S|T], N) :-
    countLowerCase(S, N1),
    countLowerCase(T, N2),
    N is N1 + N2, !.
countLowerCase(S, 1) :-  code_type(S, lower).
countLowerCase(_, 0).

countLowerCase(L, Ss) :-
    countLowerCase(Ss, N),
    Z is N / L,
    write(Z), nl, !.

countSymbol([], 0) :- !.
countSymbol([S|T], N) :-
    countSymbol(S, N1),
    countSymbol(T, N2),
    N is N1 + N2, !.
countSymbol(S, 1) :- (S >= 33, S =< 64).
countSymbol(S, 1) :- (S >= 91, \+ S = 95, S =< 96).
countSymbol(S, 1) :- (S >= 123, S =< 126).
countSymbol(_, 0).

countSymbol(L, Ss) :-
    countSymbol(Ss, N),
    Z is N / L,
    write(Z), nl, !.




