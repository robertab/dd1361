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
    if lexer.hasMoreTokens():
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
    return
                

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
        

    

