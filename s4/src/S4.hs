module S4 where


import Text.Parsec (ParseError, parse, many1, digit, many, try, sepBy, spaces, char, choice, eof, endBy, manyTill, count, chainl1, letter)
import Text.Parsec.Prim ((<?>))
import Text.Parsec.String (Parser)
import Text.Parsec.Char (anyChar, string, oneOf, space, endOfLine, noneOf)
import Data.Char
import Control.Applicative ((<|>), (<$>), (<*), (*>), (<$))
import Control.Monad (void)
     
type ColorCode = String

data Expr = Num Integer
                    | Var String
                    | Add Expr Expr
                    | Parens Expr
                    | Mul Expr Expr
                    | Div Expr Expr
                      deriving (Eq,Show)

data Token
  = Forw 
  | Back 
  | LeftI 
  | RightI 
  | Color
  | Rep
  | Dot
  | Hash ColorCode
  | Numb Integer
  | Quote
  | Down
  | Up
  deriving (Show, Eq)

lexeme :: Parser a -> Parser a
lexeme p = p <* whitespace

instr :: Parser Token
instr = try color 
        <|> choice [try rep, right] 
        <|> dot 
        <|> up
        <|> down
        <|> back 
        <|> left 
        <|> forw 
        <|> quote
        <|> number
        <|> hash

createTokens :: String -> Either ParseError [Token]
createTokens = parse (whitespace *> many instr <* eof) ""

color :: Parser Token
color = lexeme $ string "COLOR" *> space *> return Color

rep :: Parser Token
rep = lexeme $ string "REP" *> space *> return Rep

down :: Parser Token
down = lexeme $ string "DOWN" *> return Down 

up :: Parser Token
up = lexeme $ string "UP" *> return Up 

forw :: Parser Token
forw = lexeme $ string "FORW" *> space *> return Forw

back :: Parser Token
back = lexeme $ string "BACK" *> space *> return Back

left :: Parser Token
left = lexeme $ string "LEFT" *> space *> return LeftI

right :: Parser Token
right = lexeme $ string "RIGHT" *> space *> return RightI

dot :: Parser Token
dot =  lexeme $ char '.' *> return Dot 

quote :: Parser Token
quote = lexeme (char '\"') *> return Quote

hash :: Parser Token
hash = lexeme $ do 
  char '#' 
  col <- (count 6 anyChar)   
  return (Hash col)

number :: Parser Token
number = (Numb . read) <$> lexeme (many1 digit) 

num' :: Parser Expr
num' = (Num . read) <$> lexeme (many1 digit)
var' :: Parser Expr
var' = Var <$> iden
  where
    iden = lexeme ((:) <$> firstChar <*> many nonFirstChar)
    firstChar = letter <|> char '_'
    nonFirstChar = digit <|> firstChar
parens' :: Parser Expr
parens' =
    Parens <$> (lexeme (char '(')
                *> simpleExpr'
                <* lexeme (char ')'))
term' :: Parser Expr
term' = num' <|> var' <|> parens'
simpleExpr' :: Parser Expr
simpleExpr' = chainl1 term' op
  where op = Add <$ lexeme (char '+')

whitespace :: Parser ()
whitespace = choice [comment *> whitespace,
                     simpleWhitespace *> whitespace,
                     return ()]

simpleWhitespace = void $ many1 (oneOf " \t\n")
comment = void (try (string "%") *>
                              manyTill anyChar (void (char '\n') <|> eof))

