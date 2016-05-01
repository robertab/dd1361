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
import Control.Applicative ((<|>))
import Control.Monad (void)


data Instruction = Forw Integer | Back Integer deriving Show

regularParse :: Parser a  -> String -> Either ParseError a
regularParse p = parse p ""

testInstruction :: Parser Instruction
testInstruction = try forw <|> back

parseTest :: String -> Either ParseError Instruction
parseTest = regularParse forw 

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
