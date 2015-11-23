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

from token import *
from syntaxfel import Syntaxerror
from constants import *


class Lexer:
    def __init__(self, file):
        self.tokens = []
        self.currentToken = 0
        self.row = 1
        self.file = file
        self.createTokens() 

    def createTokens(self):
        replacedString = re.sub(commentPattern, '\n', self.file.lower())
        listOfMatches = re.findall(pattern, replacedString)
        for token in listOfMatches:
            if '\n' in token           : self.row += token.count('\n')
            if token[0:5] == 'color'   : self.tokens.append(Token(COLOR, self.row)) 
            elif token[0:4] == 'forw'  : self.tokens.append(Token(FORW, self.row))
            elif token      == '.'     : self.tokens.append(Token(DOT, self.row))
            elif token[0:4] == 'back'  : self.tokens.append(Token(BACK, self.row))
            elif token[0:4] == 'left'  : self.tokens.append(Token(LEFT, self.row))        
            elif token[0:5] == 'right' : self.tokens.append(Token(RIGHT, self.row))        
            elif token      == "down"  : self.tokens.append(Token(DOWN, self.row))
            elif token      == "up"    : self.tokens.append(Token(UP, self.row))
            elif token[0:3] == "rep"   : self.tokens.append(Token(REP, self.row, token))
            elif token      == '"'     : self.tokens.append(Token(QUOTE, self.row))
            elif token[0]   == '#'     : self.tokens.append(Token(COLORCODE, self.row, token))
            elif token[0]   == '\n'    : pass 
            elif token.isspace()       : pass 
            
            elif token.isdigit() and token[0] != '0':
                self.tokens.append(Token(NUMBER, self.row, int(token)))
            else:
                self.tokens.append(Token(INVALID, self.row, token))
                return

    def peek(self):
        return self.tokens[self.currentToken]

    def dequeue(self):
        result = self.peek()
        self.currentToken += 1
        return result

    def hasMoreTokens(self):
        return self.currentToken < len(self.tokens)

