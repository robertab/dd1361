"""
Author:         Robert Åberg, Sara Ervik
Assignmet:      S2, Sköldpaddegrafik

"""
from constants import *
from math import *

output = ['#0000FF', 0.0000, 0.0000, 0.0000, 0.0000]

def printOutput(DOWN):
    if DOWN:
        for i in range(len(output)):
            print(output[i], end="\t")
        print()

def calculateAngle(tree):
    return (pi * tree.num) / 180
    
    
    

# Testar utan reps
def parse(tree, DOWN=False, ANGLE=0):
    output[1] = output[3]
    output[2] = output[4]
    if tree == None: return 0
    else:
        if tree.token.type == 'down':   DOWN = True
        elif tree.token.type == 'up':   DOWN = False
        elif tree.token.type == 'color': output[0] = tree.num
        elif tree.token.type == 'left': ANGLE += calculateAngle(tree)
        elif tree.token.type == 'forw':
            output[3] += tree.num * cos(ANGLE)
            output[4] += tree.num * sin(ANGLE)
            printOutput(DOWN)
        elif tree.token.type == 'back':
            output[3] -= tree.num * cos(angle)
            output[4] -= tree.num * sin(angle)
            printOutput(DOWN)
    print(ANGLE)
    # Eventuellt avrundar vi angle till int, alltså 0. testfall fungerar inte.

    return parse(tree.next, DOWN)
    
