module LexerTest where

import Control.Applicative ((<*))
import Text.Parsec
import Text.Parsec.String
import Text.Parsec.Expr
import Text.Parsec.Token
import Text.Parsec.Language

data Instr = Rep Expr Instr
             | MRep Expr [Instr]
             | String := Expr
             | Forw Expr
             | Back Expr
             | LeftI Expr
             | RightI Expr
             | Color String
             | Up
             | Down
  deriving (Show, Eq)

data Expr = Num Int
          | Var String
          | Neg Expr
          | Pos Expr
          | Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Div Expr Expr
  deriving (Show, Eq)
  

def = emptyDef { commentStart    = "%"
               , commentLine     = "%"
               , commentEnd      = "\n"
               , identStart      = letter 
               , identLetter     = alphaNum
               , caseSensitive   = False
               , opStart         = oneOf "="
               , reservedOpNames = ["="]
               , reservedNames   = [ "rep"
                                   , "forw"
                                   , "back"
                                   , "left"
                                   , "right"
                                   , "up"
                                   , "down"
                                   , "color"
                                   ]
               }
               
TokenParser { parens = m_parens
            , identifier = m_identifier
            , reservedOp = m_reservedOp
            , reserved = m_reserved
            , hexadecimal = m_hexadecimal
            , whiteSpace = m_whiteSpace
            , lexeme = m_lexeme
            , dot = m_dot
            , semiSep1 = m_semiSep1 } = makeTokenParser def

exprparser :: Parser Expr
exprparser = buildExpressionParser table term <?> "expression"
table = [
   [ Prefix (m_reservedOp "-" >> return Neg)
   , Prefix (m_reservedOp "+" >> return Pos) ]
 , [ Infix  (m_reservedOp "*" >> return Mul) AssocLeft
   , Infix  (m_reservedOp "/" >> return Div) AssocLeft ]
 , [ Infix  (m_reservedOp "+" >> return Add) AssocLeft
   , Infix  (m_reservedOp "-" >> return Sub) AssocLeft
  ]
 ]
 
createTokens :: String -> Either ParseError [Instr] 
createTokens = parse mainparser "(stdin)"

mainparser :: Parser [Instr]
mainparser = m_whiteSpace >> many instrparser <* eof

instrparser :: Parser Instr
instrparser = var 
           <|> forw  <|> choice [try rep, try mrep]
           <|> back  <|> left
           <|> right <|> color
           <|> up    <|> down

term = m_parens exprparser 
       <|> Var <$> m_identifier <|> num

num :: Parser Expr
num = (Num . read) <$> (many1 digit)

var :: Parser Instr
var = (:=) <$> (m_identifier <* m_reservedOp "=") <*> (exprparser <* m_dot)

forw :: Parser Instr
forw = Forw <$> (m_reserved "forw" *> exprparser <* m_dot)

back :: Parser Instr
back = Back <$> (m_reserved "back" *> exprparser <* m_dot)

left :: Parser Instr
left = LeftI <$> (m_reserved "left" *> exprparser <* m_dot)

right :: Parser Instr
right = RightI <$> (m_reserved "right" *> exprparser <* m_dot)

up :: Parser Instr
up = m_reserved "up" *> m_dot *> return Up

down :: Parser Instr
down = m_reserved "down" *> m_dot *> return (Down)

color :: Parser Instr
color = Color <$> (m_reserved "color" 
                   *> m_lexeme (char '#') *> count 6 hexDigit <* m_dot)

rep :: Parser Instr
rep = Rep <$> (m_reserved "rep" *> exprparser <* m_whiteSpace) <*> instrparser

mrep :: Parser Instr
mrep = do
  m_reserved "rep"
  e <- m_lexeme $ exprparser  
  char '\"' >> m_whiteSpace
  i <- many instrparser
  char '\"' >> m_whiteSpace
  return (MRep e i)
