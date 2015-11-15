
% File:   intro.pl
% Author: Dilian Gurov, KTH CSC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Föreläsning 1: Introduktion till logisk programmering och Prolog
%
% - Deklarativ och logisk programmering
% - Satser: Fakta och Regler
% - Logisk versus procedurell läsning
% - Rekursion
%
% Läs boken: Brna, kap. 1-5

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% - Satser: fakta

far(agnes, petter).  
far(per, petter).
far(anton, per).

mor(agnes, annika).
mor(per, annika).
mor(kia, agnes).
mor(anton, agnes).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% - Queries
%
% ?- far(agnes, per).
% ?- far(anton, per).
% ?- far(monika, per).   Closed world assumption!!!
%
% Vi kan också ställa frågor som involverar variabler:
%
% ?- far(agnes, X).   Vem är far till agnes? Eller, 
%                     för vilka X är det sant att fadern till agnes är X?
%
% ?- far(X, petter).  Vems fader är petter? 
%                     Flera svar möjliga! Fås fram med 'n' eller ";".
%
% ?- far(X, Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% - Satser: regler

farmor(X, Y) :- far(X, Z), mor(Z, Y).

% Några frågor:
%
% ?- farmor(agnes, annika).
% ?- farmor(anton, annika).
% ?- farmor(anton, X).
% ?- farmor(X, annika).
% ?- farmor(X, Y).
%
% ?- far(anton, X), mor(X, annika).

% Disjunktiva regler ges som separata regler:

foralder(X, Y) :- far(X, Y).
foralder(X, Y) :- mor(X, Y).

% Några frågor:
%
% ?- foralder(agnes, petter).
% ?- foralder(agnes, per).
% ?- foralder(agnes, X).
% ?- foralder(X, Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% - Rekursion

forfader(X, Y) :- foralder(X, Y).
forfader(X, Y) :- foralder(X, Z), forfader(Z, Y).

% Några frågor:
%
% ?- forfader(kia, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


