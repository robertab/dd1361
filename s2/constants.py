

"""Konstanter"""

pattern = '\s+|\.|\d+|\"|#[A-Fa-f0-9]{6}|forw\s|color\s|left\s|back\s|right\s|down|up|rep\s[1-9]\d*\s|%.+\n|.'

commentPattern = '%.*\n?'
ANGLE = 0
DOWN = False

COLOR, DOT, FORW, BACK, LEFT, RIGHT, DOWN, UP, REP, WHITESPACE, COLORCODE, QUOTE, NUMBER, COMMENT, INVALID = \
"color", 'dot', 'forw', 'back', 'left', 'right', 'down', 'up', 'rep', 'whitespace', 'colorcode', \
'quote', 'number', 'comment', 'invalid'

output = ['#0000FF', 0, 0, 0, 0]


if __name__ == '__main__':
    main()
