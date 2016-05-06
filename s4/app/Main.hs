module Main where



--import Data.Char

--import Lexer
--import S4
--import Parse
import LexerTest

main :: IO ()
main = interact (show . createTokens)
