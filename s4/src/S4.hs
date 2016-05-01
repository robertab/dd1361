module S4 
          (regularParse
          ,parseTest
          ,forw
          ,testInstruction
          ,
          ) where


import Text.Parsec (ParseError, parse, many1, digit, many, try, spaces, char)
import Text.Parsec.String (Parser)
import Text.Parsec.Char (anyChar, string, oneOf, space )
import Data.Char
import Control.Applicative ((<|>), (<$>), (<*), (*>), (<$))
import Control.Monad (void)


data Instruction
  = Forw Integer
  | Back Integer
  | LeftI Integer
  | RightI Integer
  | Color Integer
  | Down
  | Up
  deriving ((Show))

regularParse :: Parser a  -> String -> Either ParseError a
regularParse p = parse p ""

testInstruction :: Parser Instruction
testInstruction = try forw <|> back <|> left <|> right <|> up <|> down <|> color

parseTest :: String -> Either ParseError Instruction
parseTest = regularParse forw 

down :: Parser Instruction
down = do
  f <- string "DOWN"
  spaces
  char '.'
  return Down

up :: Parser Instruction
up = do
  f <- string "UP"
  spaces
  char '.'
  return Up
  
color :: Parser Instruction
color = do
  f <- string "COLOR"
  many1 space
  char '#'
  col <- many1 digit
  spaces
  char '.'
  return (Color (read col))

left :: Parser Instruction
left = do
  f <- string "LEFT"
  many1 space
  n <- many1 digit
  spaces
  char '.'
  return (LeftI (read n))

right :: Parser Instruction
right = do
  f <- string "RIGHT"
  many1 space
  n <- many1 digit
  spaces
  char '.'
  return (RightI (read n))

forw :: Parser Instruction
forw = do
     f <- string "FORW"
     many1 space
     n <- many1 digit
     spaces
     char '.'
     return (Forw (read n))

back :: Parser Instruction
back = do
       f <- string "BACK"
       many1 space
       n <- many1 digit
       spaces
       char '.'
       return (Back (read n))
