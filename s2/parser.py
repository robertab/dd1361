#encoding: UTF-8

"""
Author:         Robert Åberg, Sara Ervik
Assignment:     S2, Sköldpaddegrafik
File:           parser.py
"""



from constants import *
from math import *
import sys

DOWN = False

def printOutput():
    global DOWN
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
            printOutput()
        elif tree.token.type == 'back':
            output[3] -= tree.num * cos(ANGLE)
            output[4] -= tree.num * sin(ANGLE)
            printOutput()
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
        elif tree.token.type == 'forw'  :
            output[3] += tree.num * cos(ANGLE)
            output[4] += tree.num * sin(ANGLE)
            printOutput()
        elif tree.token.type == 'back':
            output[3] -= tree.num * cos(ANGLE)
            output[4] -= tree.num * sin(ANGLE)
            printOutput()
        elif tree.token.type == 'rep':
            for i in range(tree.num):
                innerParse(tree.down)
    parse(tree.next)
    
if __name__ == '__main__':
    main()
