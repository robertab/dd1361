from lexer import *
from syntaxfel import Syntaxerror


class Tree:
    def __init__(self, token=None, num=1):
        self.next = None
        self.down = None
        self.token = token
        self.num = num
    
def readProgram(tokens):
    t = readInstruction(tokens)
    if not tokens.hasMoreTokens():
        return t
    else:
        t.next = readProgram(tokens)
        return t

def readInstruction(tokens):
    if tokens.hasMoreTokens() and \
       tokens.peek().type == 'down' or\
       tokens.peek().type == 'up':
        branch = readPencil(tokens)
        return branch
    elif tokens.hasMoreTokens() and \
         tokens.peek().type == 'forw' or  \
         tokens.peek().type == 'back' or  \
         tokens.peek().type == 'right' or \
         tokens.peek().type == 'left':
        branch = readMoves(tokens)
        return branch
    elif tokens.hasMoreTokens() and \
         tokens.peek().type == 'color':
        branch = readColor(tokens)
        return branch
    else:
        raise Syntaxerror("Syntaxfel")
                
def readPencil(tokens):
    t = Tree(tokens.peek())
    tokens.dequeue()
    if tokens.hasMoreTokens() and \
       tokens.peek().type == 'dot':
        tokens.dequeue()
        return t
    raise Syntaxerror("Syntaxfel")
    
def readMoves(tokens):
    t = Tree(tokens.peek())
    tokens.dequeue()
    if tokens.hasMoreTokens() and \
       tokens.peek().type == 'number':
        t.num = tokens.peek().value
        tokens.dequeue()
        if tokens.hasMoreTokens() and \
           tokens.peek().type == 'dot':
            tokens.dequeue()
            return t
    raise Syntaxerror("Syntaxfel")

def readColor(tokens):
    t = Tree(tokens.peek())
    tokens.dequeue()
    if tokens.hasMoreTokens() and \
       tokens.peek().type == 'colorcode':
        t.num = tokens.peek().value
        tokens.dequeue()
        if tokens.hasMoreTokens() and \
           tokens.peek().type == 'dot':
            tokens.dequeue()
            return t
    raise Syntaxerror("Syntaxfel")
        
def main():
    file = stdin.readlines()
    try:
        l = Lexer()
        list_of_tokens = l.lexer(file)
        result = readProgram(l)
        return "korrekt"
    except Syntaxerror as fel:
        if not l.hasMoreTokens():
            return str(fel) + " på rad " + str(l.row)
        else:
            return str(fel) + " på rad " + str(l.peek().row)



if __name__ == '__main__':
    print(main())


    

