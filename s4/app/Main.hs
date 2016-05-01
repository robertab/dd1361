module Main where


import S4

import Data.Char

main :: IO ()
main = interact (show . regularParse testInstruction . map toUpper)
