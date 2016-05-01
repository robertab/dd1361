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
testInstruction =
  try
    forw <|> back <|> left <|> right <|> up <|> down <|> color

parseTest :: String -> Either ParseError Instruction
parseTest = regularParse forw 

down :: Parser Instruction
down = do
  (string "DOWN") <* spaces <* (char '.')
  return Down

up :: Parser Instruction
up = do 
  (string "UP") <* spaces <* (char '.')
  return Up

color :: Parser Instruction
color = do
  instr <- string "COLOR" <* (many1 space) <* (char '#')
  col <- (Color . read) <$> many1 digit <* spaces <* char '.'
  return col

left :: Parser Instruction
left = do
  instr <- string "LEFT" <* many1 space
  l <- (LeftI . read) <$> many1 digit <* spaces <* char '.'
  return l

right :: Parser Instruction
right = do
  instr <- string "RIGHT" <* many1 space
  r <- (RightI . read) <$> many1 digit <* spaces <* char '.'
  return r

forw :: Parser Instruction
forw = do
  f <- string "FORW" <* many1 space
  for <- (Forw . read) <$> many1 digit <* spaces <* char '.'
  return for

back :: Parser Instruction
back = do
  f <- string "BACK" <* many1 space
  for <- (Back . read) <$> many1 digit <* spaces <* char '.'
  return for

