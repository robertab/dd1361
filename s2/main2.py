# -*- encoding: utf-8 -*-
from sys import *

from syntaxfel import Syntaxerror
from constants import *
from tree import *
from lexer import *
from token import *

sys.setrecursionlimit(30000)


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
            sys.stdout.write( str(fel) + " p",end = ""+ u"å".encode('UTF8')+ " rad " + str(lexer.row)+"/n") 
        else:
            print str(fel) + " p"+ u"a".encode("utf-8")+" rad " + str(lexer.peek().row)

if __name__ == '__main__':
    main()
