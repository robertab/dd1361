from sys import stdin
import re

from token import Token 
from syntaxfel import Syntaxerror
from constants import *


class Lexer:
    def __init__(self):
        self.tokens = []
        self.currentToken = 0
        self.row = 0

    def lexer(self, file):
        """
        funktion lexer som omvandlar indata till tokens
        """
        for line in file:
            self.row += 1
            list_of_matches = re.findall(pattern,line.lower())
            for token in list_of_matches:
                if token[0:5]   == 'color' : self.tokens.append(Token(COLOR, self.row)) 
                elif token[0:4] == 'forw'  : self.tokens.append(Token(FORW, self.row))
                elif token      == '.'     : self.tokens.append(Token(DOT, self.row))
                elif token[0:4] == 'back'  : self.tokens.append(Token(BACK, self.row))
                elif token[0:4] == 'left'  : self.tokens.append(Token(LEFT, self.row))        
                elif token[0:4] == 'right' : self.tokens.append(Token(RIGHT, self.row))        
                elif token      == "down"  : self.tokens.append(Token(DOWN, self.row))
                elif token      == "up"    : self.tokens.append(Token(UP, self.row))
                elif token[0:3] == "rep"   : self.tokens.append(Token(REP, self.row))
                elif token      == '"'     : self.tokens.append(Token(QUOTE, self.row))
                elif token[0]   == '#'     : self.tokens.append(Token(COLORCODE, self.row, token))
                elif token.isspace()       : pass
                elif token[0]   == '%'     : pass
                elif token.isdigit()       : self.tokens.append(Token(NUMBER, self.row, int(token)))
                else:
                    self.tokens.append(Token(INVALID, self.row, token)) #Eventuell raise. just nu sparas INVALID tokens i listan


            
    def peek(self):
        return self.tokens[self.currentToken]

    def dequeue(self):
        result = self.peek()
        self.currentToken += 1
        return result

    def hasMoreTokens(self):
        return self.currentToken < len(self.tokens)

                                    

