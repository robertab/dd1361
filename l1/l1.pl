% Författare: Robert Åber, Sara Ervik
% Kurs: DD1361
% Fil: L1.pl
%-------------------------------------------------


%% %------------------ DEL 1----------------------

%- Fakta om vokaler
vowel(101).
vowel(97).
vowel(105).
vowel(111).
vowel(117).
vowel(121).
vowel(148).
vowel(132).
vowel(134).
%---------

fib(N, F) :-
    fibcounter(N, 0, 1, F).

fibcounter(N, X, Y, F) :-
    N > 0,
    FibNr is X  + Y,
    Counter is N - 1,
    fibcounter(Counter, Y, FibNr, F).

fibcounter(0, Y, _, Y).

%% %----------------- DEL 2 --------------------

rovarsprak([], []).

rovarsprak([Head | Tail], [Head, 111, Head | RovarText]) :- %Om inte vokal
    \+ vowel(Head),
    rovarsprak(Tail, RovarText).

rovarsprak([Head | Tail], [Head | RovarText]) :- % Om vokal
    vowel(Head),
    rovarsprak(Tail, RovarText).


%----------------- DEL 3----------------------
medellangd(Text, AvgLen) :-
    counter(Text, C, W),
    AvgLen is C / W.

counter([F | []], 1,1) :-
    char_type(F, alpha), !.

counter([], 0, 0).
counter([F,S | Tail], C, W) :- % Undersöker om det första tecknet är bokstav och det andra inte är det
    char_type(F, alpha), \+ char_type(S, alpha),!,
    counter(Tail, CLen, WLen),
    C is CLen + 1,
    W is WLen + 1.

counter([F | Tail], C, W) :- % Underslker om de två första tecknen är bokstäver
    char_type(F, alpha),!,
    counter(Tail, CLen, W),
    C is CLen + 1.

counter([_ | Tail], C, W) :-
    counter(Tail, C, W).

%------------------DEL 4-----------------------

skyffla([], []) :- !.
skyffla([Fst | []], [Fst]):- !.
skyffla( Text, Skyfflad ) :-
    sort(Text, Frontlist, Backlist), %Skickar in de båda listorna och shufflar
    skyffla(Backlist, Temp),!, % Skickar in [2,4,6,8]
    append(Frontlist, Temp, Skyfflad).

sort( [], [], [] ).
sort([Fst | [] ], [Fst], []).
sort( [Fst,Snd | Tail], [Fst | Frontlist], [Snd | Backlist] ) :- % Frontlist : 1 3 5, Backlist : 2 4
    sort( Tail, Frontlist, Backlist ).


%------------------------------------------------
