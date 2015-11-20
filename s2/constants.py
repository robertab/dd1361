"""Konstanter"""

pattern = '\s+|\.|\d+|\"|#[A-Fa-f0-9]{6}|forw\s|color\s|left\s|back\s|right\s|down|up|rep\s\d+\s|%.+\n|.'


COLOR, DOT, FORW, BACK, LEFT, RIGHT, DOWN, UP, REP, WHITESPACE, COLORCODE, QUOTE, NUMBER, COMMENT, INVALID = \
"color", 'dot', 'forw', 'back', 'left', 'right', 'down', 'up', 'rep', 'whitespace', 'colorcode', \
'quote', 'number', 'comment', 'invalid'
