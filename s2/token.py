"""Klass token"""
class Token:
    def __init__(self, type, row, value=None):
        "En Token klass för att alla tokens"
        self.type = type
        self.row = row
        self.value = value

        
