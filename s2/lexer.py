"""
Author:         Robert Åberg, Sara Ervik
Assignment:     S2, Sköldpaddegrafik

Här delas indata in i tokens med hjälp av regex som jämför enligt angivna regler.
Tveksam dubbel for-loop som genom söker input till EOF. 
Klassen Lexer består av fyra metoder, createTokens, peek, hasMoreTokens, dequeue.
Klassen initieras med en tom lista, en räknare som håller reda på positionen i listan,
radräknare som skickas med i Token-objektet, indata (Som i det här fallet skickas in som
en fil samt metoden createTokens som skapar tokens och lagras i listan.
"""


from sys import stdin
import re

from token import Token 
from syntaxfel import Syntaxerror
from constants import *


class Lexer:
    def __init__(self, file):
        self.tokens = []
        self.currentToken = 0
        self.row = 0
        self.file = file
        self.createTokens() 

    def createTokens(self):
        for line in self.file:
            self.row += 1
            list_of_matches = re.findall(pattern,line.lower())
            for token in list_of_matches:
                if token[0:5]   == 'color' : self.tokens.append(Token(COLOR, self.row)) 
                elif token[0:4] == 'forw'  : self.tokens.append(Token(FORW, self.row))
                elif token      == '.'     : self.tokens.append(Token(DOT, self.row))
                elif token[0:4] == 'back'  : self.tokens.append(Token(BACK, self.row))
                elif token[0:4] == 'left'  : self.tokens.append(Token(LEFT, self.row))        
                elif token[0:5] == 'right' : self.tokens.append(Token(RIGHT, self.row))        
                elif token      == "down"  : self.tokens.append(Token(DOWN, self.row))
                elif token      == "up"    : self.tokens.append(Token(UP, self.row))
                elif token[0:3] == "rep"   : self.tokens.append(Token(REP, self.row))
                elif token      == '"'     : self.tokens.append(Token(QUOTE, self.row))
                elif token[0]   == '#'     : self.tokens.append(Token(COLORCODE, self.row, token))
                elif token.isspace()       : pass # Bortser från whitespace. Ej nödvändigt.
                elif token[0]   == '%'     : pass # Bortser från kommentarer.
                elif token.isdigit() and token[0] != '0':
                    self.tokens.append(Token(NUMBER, self.row, int(token)))

                else:
                    self.tokens.append(Token(INVALID, self.row, token))
            
    def peek(self):
        return self.tokens[self.currentToken]

    def dequeue(self):
        result = self.peek()
        self.currentToken += 1
        return result

    def hasMoreTokens(self):
        return self.currentToken < len(self.tokens)

                                    

