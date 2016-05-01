module Main where


import Data.List (union, sort)

main :: IO ()
main = interact (unwords . map show . sort . partition . handleInput)


--handleInput :: String -> [String]
handleInput =  strToInt . map words . lines

strToInt :: [[String]] -> [[Integer]]
strToInt = map (map read)

partition :: [[Integer]] -> [Integer]
partition ((x:_):xs:_) = xs `union` walls' xs `union` walls `union` [x]
  where walls = map (\w -> x - w) xs
        walls' xs' = [abs (x'- y) | x' <- xs', y<- xs, y /= x']
