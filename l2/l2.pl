%% Author    : Robert Åberg, Sara Ervik
%% Uppgift   : L2, Konspirationsdetektion.
%% Kurs      : DD1361



spider(X) :-
    setof(Y, person(Y), Persons),!,                         % Skapar hela listan med personer
    select(X, Persons, NoSpiders),                          % Tar ut en person från listan. Ev spindel
    isSpider(X,NoSpiders).

isSpider(S, NoSpiders) :-
    setof(X, mutual(X, S), SpiderFriends),
    allKnowsSomeone(NoSpiders, [S|SpiderFriends]),          % Alla känner antingen spindeln eller spindelns vän. 
    conspirator(SpiderFriends, [], Conspirators),           % Skickar spindels vänner för att undersöka om de kan vara konspiratörer.
    subtract(NoSpiders, Conspirators, NoConspirators),      % Tar bort konspiratörerna från listan med alla personer utan spindel
    allKnowsSomeone(NoConspirators,Conspirators),!.         % Slutligen kollar vi om alla (exklusive konsp, spindel) känner någon konsp.
    
conspirator([], Final, Final).
conspirator([Head | PossibleConsp], Consp, Final) :-
    isNotKnown(Head, Consp),                                % Kravet för en konsp är att de inte ska känna varandra
    conspirator(PossibleConsp, [Head | Consp], Final).


conspirator([_ | PossibleConsp], Consp, Final) :-
    conspirator(PossibleConsp, Consp, Final). 


allKnowsSomeone([], _ ).                                    % Kollar som att alla i en lista känner någon i en annan lista
allKnowsSomeone([X | Tail], List) :-
    isKnown(X, List),
    allKnowsSomeone(Tail, List).

% X vän med Y  <=> Y vän med X.
mutual(PersonX, PersonY) :- knows(PersonY, PersonX); knows(PersonX, PersonY). 

isKnown(X, List) :- member(Y, List),  mutual(X, Y),!. 
isNotKnown(X, List) :- \+ isKnown(X, List).			  
