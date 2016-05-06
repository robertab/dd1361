module Lexer where

import Text.Parsec (ParseError, between, string, many1, space, parseTest, spaces, try, count, parse, eof, choice, manyTill, chainl1) 
import Text.Parsec.String (Parser)
import Text.Parsec.Char (char, digit, hexDigit, noneOf, oneOf, anyChar, letter, alphaNum)
import qualified Data.Map as M
import Text.Parsec.Expr
import Text.Parsec.Token hiding (lexeme)
import Text.Parsec.Language
import Data.Char
import Control.Applicative
import Control.Monad



data Expr = 
    Num Double 
  | Add Expr Expr 
  | Sub Expr Expr 
  | Mul Expr Expr 
  | Div Expr Expr
  | Neg Expr deriving (Show, Eq)

data Instr = 
    MRep Expr [Instr]
  | Color String 
  | Rep Expr Instr
  | Back Expr
  | LeftI Expr
  | RightI Expr
  | Var String Expr
  | Down
  | Up 
  | Forw Expr deriving (Show, Eq)


instr :: Parser Instr
instr = try color 
        <|> up 
        <|> forw 
        <|> back 
        <|> down 
        <|> choice [try mrep, try rep, try right, try var]
        <|> left

lexeme :: Parser a -> Parser a
lexeme p = p <* whitespace

mrep :: Parser Instr
mrep = lexeme $ do
  string "rep" 
  many1 space 
  e <- expr 
  many1 space
  i <- between (char '\"') (char '\"') (many instr)
  return (MRep e i)

rep :: Parser Instr
rep = lexeme $do
  string "rep" *> many1 space 
  e <- expr
  many1 space
  i <- instr
  return (Rep e i)

up :: Parser Instr
up = lexeme $ string "up" *> spaces *> char '.' *> spaces *> return Up

down :: Parser Instr
down = lexeme $ string "down" *> spaces *> char '.' *> spaces *> return Down

forw :: Parser Instr
forw = lexeme $ do
  string "forw" *> many1 space 
  num <- expr 
  spaces
  char '.'
  spaces
  return (Forw num) 

right :: Parser Instr
right = lexeme $ do
  string "right" *> many1 space 
  num <- expr 
  spaces
  char '.'
  spaces
  return (RightI num) 

left :: Parser Instr
left = lexeme $ do
  string "left" *> many1 space 
  num <- expr 
  spaces
  char '.'
  spaces
  return (LeftI num) 

back :: Parser Instr
back = lexeme $ do
  string "back" *> many1 space 
  num <- expr 
  spaces 
  char '.'
  spaces
  return (Back num) 

color :: Parser Instr
color = lexeme $ do
  c <- string "color" *> whitespace *> char '#'
  code <- count 6 hexDigit 
  char '.' 
  spaces
  return (Color code)


lexer :: TokenParser ()
lexer = makeTokenParser (javaStyle { opStart  = oneOf "+-*/"
                                   , opLetter = oneOf "+-*/" })

expr :: Parser Expr
expr = (flip buildExpressionParser) term $ [
                    [ Prefix (reservedOp lexer "-" >> return Neg)
                    , Prefix (reservedOp lexer "+" >> return id) ]
                  , [ Infix  (reservedOp lexer "*" >> return Mul) AssocLeft
                    , Infix  (reservedOp lexer "/" >> return Div) AssocLeft ]
                  , [ Infix  (reservedOp lexer "+" >> return Add) AssocLeft
                    , Infix  (reservedOp lexer "-" >> return Sub) AssocLeft ]
                  ]

term :: Parser Expr
term = parens lexer expr <|> try num

num :: Parser Expr
num = (Num . read) <$> (many1 digit)

createTokens :: String -> Either ParseError [Instr] 
createTokens = parse (whitespace *> many instr <* eof) ""

whitespace :: Parser ()
whitespace = choice [comment *> whitespace,
                     simpleWhitespace *> whitespace,
                     return ()]

simpleWhitespace = void $ many1 (oneOf " \t\n")
comment = void (try (string "%") *>
                              manyTill anyChar (void (char '\n') <|> eof))


var :: Parser Instr
var = Var <$> variable <*> expression
      where 
      variable = lexeme ((:) <$> firstChar <*> many nonFirstChar)
      firstChar = noneOf "0123456789\n \t\r%.+-*\\()=" <|> alphaNum
      nonFirstChar = digit <|> firstChar <|> char '=' <|> char '.' 
      expression = expr

