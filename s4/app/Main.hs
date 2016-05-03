module Main where


import S4

import Data.Char

main :: IO ()
main = interact (show . createTokens . map toUpper)
