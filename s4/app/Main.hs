module Main where



import Parse
import LexerTest

main :: IO ()
main = do
  input <- getContents
  putStrLn "<?xml version=\"1.0\"?>\n<!DOCTYPE svg PUBLIC\
           \ \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n\
           \<svg version=\"1.1\" x=\"0px\" y=\"0px\" width=\"612px\" height=\"792px\" viewBox = \"0 0 612 792\">\n" 

  runLeonardo (createTokens input) 
  putStrLn "</svg>\n\n"

