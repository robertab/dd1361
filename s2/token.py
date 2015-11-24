#encoding: UTF-8
"""
Author:         Robert Åberg, Sara Ervik
Assignment:     S2, Sköldpaddegrafik
File:           token.py
"""

class Token:
    def __init__(self, type, row, value=None):
        "En Token klass för att alla tokens"
        self.type = type
        self.row = row
        self.value = value

        
