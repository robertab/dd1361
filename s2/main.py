from sys import stdin
import re

from token import Token 
from syntaxfel import Syntaxerror
from constants import *

    


def lexer(file):
    """
    funktion lexer som omvandlar indata till tokens
    """
    tokens = Lexer()
    row = 1
    for line in file:
        list_of_matches = re.findall(pattern,line.lower())
        for token in list_of_matches:
            if token == "color":   tokens.append(Token(COLOR, row))
            elif token[0] == '%':  tokens.append(Token(COMMENT, row, token)) 
            elif token == "forw":  tokens.append(Token(FORW, row))
            elif token == '.':     tokens.append(Token(DOT, row))
            elif token == "back":  tokens.append(Token(BACK, row))
            elif token == "left":  tokens.append(Token(LEFT, row))        
            elif token == "right": tokens.append(Token(RIGHT, row))        
            elif token == "down":  tokens.append(Token(DOWN, row))
            elif token == "up":    tokens.append(Token(UP, row))
            elif token == "rep":   tokens.append(Token(REP, row))
            elif token == '"':     tokens.append(Token(QUOTE, row))
            elif token[0] == '#':  tokens.append(Token(COLORCODE, row, token))
            elif token.isspace():  tokens.append(Token(WHITESPACE, row))
            elif token.isdigit():  tokens.append(Token(NUMBER, row, int(token)))
            else:
                tokens.append(Token(INVALID, row, token)) #Eventuell raise. just nu sparas INVALID tokens i listan.
        row += 1
    return tokens
        
    


if __name__ == '__main__':
    main()
                                           
                                    

