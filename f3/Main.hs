{-# OPTIONS_GHC -Wall #-}

-- Author: Robert Åberg, Sara Ervik

module Main where

import F3       


extractFromList            :: [String] -> [MolSeq]
extractFromList []         = []
extractFromList (x1:x2:xs) = string2seq x1 x2 : extractFromList xs 

main         :: IO ()
main = do
  input      <- getContents
  let input' = (extractFromList . words) input
  putStrLn $ (show . distanceMatrix) input'
          
  
  
  
  
  










  


