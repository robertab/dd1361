module F1 where

import           Data.Char
import           Data.List
{-
Författare: Sara Ervik, Robert Åberg
Kurs:       DD1361
Laboration: F1
-}

-- Lab1 deluppgift 1. Fibonacci-talen--------------------------

fib :: Int -> Int
fib n
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = fib (n - 1) + fib (n - 2)

---------------end of assignment------------------------------

------------ Lab1 deluppgift 2. Rövarspråket ------------------

rovarspraket :: String -> String
rovarspraket =
  reverse .
  foldl' (\acc x -> if isVowel x then x : acc else x : 'o' : x : acc) []

karpsravor :: String -> String
karpsravor [] = []
karpsravor (x:xs)
  | isCons x = x : karpsravor (drop 3 (x : xs))
  | otherwise = x : karpsravor xs

isVowel :: Char -> Bool
isVowel letter = elem letter "aeiouyåäö"

isCons :: Char -> Bool
isCons letter = elem letter "bcdfghjklmnpqrstvwxz"

------------------end of assignment---------------------------


--------------- Lab 1 deluppgift 3. Medelvärden---------------

medellangd :: String -> Double
medellangd st = (fromIntegral $ charCount) / (fromIntegral $ wordCount)
  where strip =
          words $
          foldl' (\acc x -> if isAlpha x then x : acc else ' ' : acc) [] st
        charCount = length $ concat strip
        wordCount = length strip
