program :-
    open('file.txt',write, Stream),
    forall(test(L), write(Stream,L)),
    close(Stream).

test([X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12]):-
    member(X1, [-, o]),
    member(X2, [-, o]),
    member(X3, [-, o]),
    member(X4, [-, o]),
    member(X5, [-, o]),
    member(X6, [-, o]),
    member(X7, [-, o]),
    member(X8, [-, o]),
    member(X9, [-, o]),
    member(X10, [-, o]),
    member(X11, [-, o]),
    member(X12, [-, o]).




      
