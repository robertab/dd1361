# encoding: UTF-8

"""
Author:         Robert Åberg, Sara Ervik
Assignment:     S2, Sköldpaddegrafik
File:           main.py


Huvudprogrammet. Initierar programmet. Börjar med att Skapa ett objekt
från klassen Lexer(). Skickar därefter vidare lexerobjektet till
parseträdet och skapar "tree". Trädet skickas vidare till parsningen
som sköter utdata. 

All raise-hantering sköts härifrån och printar ut det korrekta
syntaxfelet. 


"""

from syntaxfel import Syntaxerror
from constants import *
from tree import *
from lexer import *
from token import *

sys.setrecursionlimit(30000) # Recursionlimit för att klara av långa nästlingar


def main():
    file = stdin.read()
    try:
        lexer = Lexer(file)
        tree = readProgram(lexer)
        if lexer.hasMoreTokens() and \
           lexer.peek().type == "quote":
            tree = readProgram(lexer)
        result = parse(tree)
        return result
    except Syntaxerror as fel:
        if not lexer.hasMoreTokens():
            print (str(fel) + " på rad " + str(lexer.row)) 
        else:
            print (str(fel) + " på rad " + str(lexer.peek().row))

if __name__ == '__main__':
    main()
