module LexerTest where

import Control.Applicative ((<*))
import Text.Parsec
import Text.Parsec.String
import Text.Parsec.Expr
import Text.Parsec.Token
import Text.Parsec.Language







data Instr = Rep Expr [Instr]
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
          | Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Div Expr Expr
  deriving (Show, Eq)
  

def = emptyDef { commentStart = "%"
               , commentEnd   = "\n"
               , identStart   = letter <|> char '\"' <|> char '#'
               , identLetter  = alphaNum
               , caseSensitive = False
               , opStart      = oneOf "=\"#"
               , reservedOpNames = ["=", ":=", "\"", "#"]
               , reservedNames = [ "rep"
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
  , Prefix (m_reservedOp "+" >> return id) ]
 , [ Infix  (m_reservedOp "*" >> return Mul) AssocLeft
  , Infix  (m_reservedOp "/" >> return Div) AssocLeft ]
 , [ Infix  (m_reservedOp "+" >> return Add) AssocLeft
  , Infix  (m_reservedOp "-" >> return Sub) AssocLeft
  ]
 ]
 
term = m_parens exprparser 
       <|> fmap Var m_identifier <|> num


num :: Parser Expr
num = (Num . read) <$> (many1 digit)

var :: Parser Instr
var = do
  v <- m_identifier
  m_reservedOp "="
  e <- exprparser
  m_dot
  return (v := e)

forw :: Parser Instr
forw = do
  m_reserved "forw"
  e <- exprparser
  m_dot
  return (Forw e)

back :: Parser Instr
back = do
  m_reserved "back"
  e <- exprparser
  m_dot
  return (Back e)

left :: Parser Instr
left = do
  m_reserved "left"
  e <- exprparser
  m_dot
  return (LeftI e)

right :: Parser Instr
right = do
  m_reserved "right"
  e <- exprparser
  m_dot
  return (RightI e)

up :: Parser Instr
up = m_reserved "up" >> m_dot >> return Up

down :: Parser Instr
down = m_reserved "down" >> m_dot >> return (Down)

color :: Parser Instr
color = do
  m_reserved "color"
  m_lexeme (char '#')
  c <- count 6 hexDigit
  m_dot
  return (Color c)

mrep :: Parser Instr
mrep = do
  m_reserved "rep"
  e <- m_lexeme $ exprparser  
  char '\"' >> m_whiteSpace
  i <- many instrparser
  char '\"' >> m_whiteSpace
  return (MRep e i)

rep :: Parser Instr
rep = do
  m_reserved "rep"
  e <- exprparser
  i <- mainparser
  return (Rep e i)

createTokens :: String -> Either ParseError [Instr] 
createTokens = parse mainparser "(stdin)"

mainparser :: Parser [Instr]
mainparser = m_whiteSpace >> many instrparser <* eof

instrparser :: Parser Instr
instrparser = try $ var 
           <|> forw 
           <|> choice [try rep, mrep]
           <|> back
           <|> left
           <|> right
           <|> color
           <|> up
           <|> down
