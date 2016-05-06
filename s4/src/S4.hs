module S4 where



import Text.Parsec (ParseError, parse, many1, digit, many, try, sepBy, spaces, char, choice, eof, endBy, manyTill, count, chainl1, letter)
import Text.Parsec.Prim ((<?>))
import qualified Text.Parsec.Expr as E
import Text.Parsec.String (Parser)
import Text.Parsec.Char (anyChar, string, oneOf, space, endOfLine, noneOf)
import Data.Char
import Control.Applicative ((<|>), (<$>), (<*), (*>), (<$))
import Control.Monad (void)
     
type ColorCode = String

data Token
  = Forw 
  | Back 
  | LeftI 
  | RightI 
  | Color
  | Rep
  | Dot
  | Hash ColorCode
  | Quote
  | Down
  | Up
  | Num Integer
  | Var String
  | Add Token Token
  | Min Token Token
  | Parens Token
  | Mul Token Token
  | Div Token Token
  deriving (Show, Eq)

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
        <|> hash
        <|> expr
        <|> parens


createTokens :: String -> Either ParseError [Token]
createTokens = parse (whitespace *> many instr <* eof) ""

lexeme :: Parser a -> Parser a
lexeme p = p <* whitespace

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
  col <- count 6 anyChar  
  return (Hash col)

num :: Parser Token
num = (Num . read) <$> lexeme (many1 digit)

var :: Parser Token
var = Var <$> iden
  where
    iden = lexeme ((:) <$> firstChar <*> many nonFirstChar)
    firstChar = letter <|> char '_' <|> char '='
    nonFirstChar = digit <|> firstChar

parens :: Parser Token
parens =
    Parens <$> (lexeme (char '(')
                *> expr
                <* lexeme (char ')'))

term :: Parser Token
term = num <|> var <|> parens

expr :: Parser Token
expr = chainl1 term op
  where op = (Add <$ lexeme (char '+')) 
             <|> (Mul <$ lexeme (char '*')) 
             <|> (Div <$ lexeme (char '/')) 
             <|> (Min <$ lexeme (char '-'))

whitespace :: Parser ()
whitespace = choice [comment *> whitespace,
                     simpleWhitespace *> whitespace,
                     return ()]

simpleWhitespace = void $ many1 (oneOf " \t\n")
comment = void (try (string "%") *>
                              manyTill anyChar (void (char '\n') <|> eof))
