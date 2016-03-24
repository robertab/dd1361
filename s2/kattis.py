
"""Konstanter"""

pattern = '\s+|\.|\d+|\"|#[A-Fa-f0-9]{6}|forw\s|color\s|left\s|back\s|right\s|down|up|rep\s\d+\s|%.+\n|.'

commentPattern = '%.*\n?'
ANGLE = 0
DOWN = False

COLOR, DOT, FORW, BACK, LEFT, RIGHT, DOWN, UP, REP, WHITESPACE, COLORCODE, QUOTE, NUMBER, COMMENT, INVALID = \
"color", 'dot', 'forw', 'back', 'left', 'right', 'down', 'up', 'rep', 'whitespace', 'colorcode', \
'quote', 'number', 'comment', 'invalid'

class Syntaxerror(Exception):
    pass




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
            elif token[0]   == '\n'    : pass #self.tokens.append(Token(COMMENT, self.row-1))
            elif token.isspace()       : pass # Bortser från whitespace. Ej nödvändigt.
            
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

                                    

"""
Author:         Robert Åberg, Sara Ervik
Assignment:     S2, Sköldpaddegrafik

Den här filen skapar syntaxträdet med hjälp av de tokens
som Lexer() skapade. Allt sköts med rekursiv medåkning och
jämförs enligt regler. Metoder till objektet lexer för att undersöka
det som kommer efter nuvarande tecken för att veta vart man ska skickas.
"""

import sys
sys.setrecursionlimit(20000)

from lexer import *
from parser import *
from syntaxfel import Syntaxerror




class Tree:
    def __init__(self, token=None, num=1):
        self.next = None
        self.down = None
        self.token = token
        self.num = num
    
def readProgram(lexer):
    t = readInstruction(lexer)
    if not lexer.hasMoreTokens():
        return t
    elif lexer.hasMoreTokens() and \
         lexer.peek().type == 'quote':
        return t
    else:
        t.next = readProgram(lexer)
        return t

def readInstruction(lexer):
    if lexer.hasMoreTokens() and \
       lexer.peek().type == 'down' or\
       lexer.peek().type == 'up':
        branch = readPencil(lexer)
        return branch
    elif lexer.hasMoreTokens() and \
         lexer.peek().type == 'forw' or  \
         lexer.peek().type == 'back' or  \
         lexer.peek().type == 'right' or \
         lexer.peek().type == 'left':
        branch = readMoves(lexer)
        return branch
    elif lexer.hasMoreTokens() and \
         lexer.peek().type == 'color':
        branch = readColor(lexer)
        return branch
    elif lexer.hasMoreTokens() and \
         lexer.peek().type == 'rep':
        branch = readRep(lexer)
        return branch
    else:
        raise Syntaxerror("Syntaxfel")
                

def extractRepNumber(rep):
    number = ""
    for character in rep:
        if character.isdigit():
            number += character
    return int(number)
            

def readRep(lexer):
    t = Tree(lexer.peek())
    t.num = (extractRepNumber(lexer.peek().value))
    lexer.row = lexer.peek().row
    lexer.dequeue()
    if lexer.hasMoreTokens() and \
       lexer.peek().type == 'quote':
        lexer.row = lexer.peek().row
        lexer.dequeue()
        t.down = readProgram(lexer)
        if lexer.hasMoreTokens() and \
           lexer.peek().type == 'quote':
            lexer.row = lexer.peek().row
            lexer.dequeue()
            return t
        raise Syntaxerror("Syntaxfel")
    elif lexer.hasMoreTokens() and \
         lexer.peek().type != 'quote':
        t.down = readInstruction(lexer)
        return t
    else:
        raise Syntaxerror("Syntaxfel")


def readPencil(lexer):
    t = Tree(lexer.peek())
    lexer.testRow = lexer.peek().row
    lexer.row = lexer.peek().row
    lexer.dequeue()
    if lexer.hasMoreTokens() and \
       lexer.peek().type == 'dot':
        lexer.row = lexer.peek().row
        lexer.dequeue()
        return t
    raise Syntaxerror("Syntaxfel")
    
def readMoves(lexer):
    t = Tree(lexer.peek())
    lexer.row = lexer.peek().row
    lexer.dequeue()
    if lexer.hasMoreTokens() and \
       lexer.peek().type == 'number':
        t.num = lexer.peek().value
        lexer.row = lexer.peek().row
        lexer.dequeue()
        if lexer.hasMoreTokens() and \
           lexer.peek().type == 'dot':
            lexer.row = lexer.peek().row
            lexer.dequeue()
            return t
    raise Syntaxerror("Syntaxfel")

def readColor(lexer):
    t = Tree(lexer.peek())
    lexer.row = lexer.peek().row
    lexer.dequeue()
    if lexer.hasMoreTokens() and \
       lexer.peek().type == 'colorcode':
        t.num = lexer.peek().value
        lexer.row = lexer.peek().row
        lexer.dequeue()
        if lexer.hasMoreTokens() and \
           lexer.peek().type == 'dot':
            lexer.row = lexer.peek().row
            lexer.dequeue()
            return t
    raise Syntaxerror("Syntaxfel")
        

    

"""
Author:         Robert Åberg, Sara Ervik
Assignmet:      S2, Sköldpaddegrafik

"""
from constants import *
from math import *

output = ['#0000FF', 0, 0, 0, 0]

def printOutput(DOWN):
    if DOWN:
        print(output[0], end='\t')
        for i in range(1,5):
            print('%.4f' % float(output[i]), end="\t")
        print()

def calculateAngle(tree):
    angle = (pi * tree.num) / 180
    return angle

def innerParse(tree):
    global DOWN
    global ANGLE
    output[1] = output[3]
    output[2] = output[4]
    if tree == None: return 0
    else:
        if tree.token.type == 'down'    :   DOWN = True
        elif tree.token.type == 'up'    :   DOWN = False
        elif tree.token.type == 'color' :   output[0] = tree.num
        elif tree.token.type == 'left'  :   ANGLE += calculateAngle(tree)
        elif tree.token.type == 'right' :   ANGLE -= calculateAngle(tree)
        elif tree.token.type == 'forw'  :
            output[3] += tree.num * cos(ANGLE)
            output[4] += tree.num * sin(ANGLE)
            printOutput(DOWN)
        elif tree.token.type == 'back':
            output[3] -= tree.num * cos(ANGLE)
            output[4] -= tree.num * sin(ANGLE)
            printOutput(DOWN)
        elif tree.token.type == 'rep': return parse(tree)
    innerParse(tree.next)

    
def parse(tree):
    global DOWN
    global ANGLE
    output[1] = output[3]
    output[2] = output[4]
    if tree == None: return 0
    else:
        if tree.token.type == 'down'    :   DOWN = True
        elif tree.token.type == 'up'    :   DOWN = False
        elif tree.token.type == 'color' :   output[0] = tree.num
        elif tree.token.type == 'left'  :   ANGLE += calculateAngle(tree)
        elif tree.token.type == 'right' :   ANGLE -= calculateAngle(tree)
        elif tree.token.type == 'forw':
            output[3] += tree.num * cos(ANGLE)
            output[4] += tree.num * sin(ANGLE)
            printOutput(DOWN)
        elif tree.token.type == 'back':
            output[3] -= tree.num * cos(ANGLE)
            output[4] -= tree.num * sin(ANGLE)
            printOutput(DOWN)
        elif tree.token.type == 'rep':
            for i in range(tree.num):
                innerParse(tree.down)
    parse(tree.next)
    
from syntaxfel import Syntaxerror
from sys import stdin

from tree import *
from lexer import *



def main():
    file = stdin.read()
    try:
        lexer = Lexer(file)
        tree = readProgram(lexer)
        result = parse(tree)
        if lexer.hasMoreTokens() and \
           lexer.peek().type == "quote":
            tree = readProgram(lexer)
        return result
    except Syntaxerror as fel:
        if not lexer.hasMoreTokens():
            print( str(fel) + " på rad " + str(lexer.row))
        else:
            print( str(fel) + " på rad " + str(lexer.peek().row))
                                    

if __name__ == '__main__':
    main()
