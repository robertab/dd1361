module F1 where
import Data.Char

{-
Författare: Sara Ervik, Robert Åberg
Kurs:       DD1361
Laboration: F1
-}

-- Lab1 deluppgift 1. Fibonacci-talen--------------------------
fib :: Int -> Int
fib n | n == 0 = 0
      | n == 1 = 1
      | otherwise = fib (n-1) + fib (n-2)
---------------end of assignment------------------------------

------------ Lab1 deluppgift 2. Rövarspråket ------------------
rovarspraket :: String -> String
rovarspraket word
  | null word = []
  | checkVowel (head word) = head word : rovarspraket (tail word)
  | checkConst (head word) =  head word : 'o' : head word : rovarspraket (tail word)

karpsravor :: String -> String
karpsravor rovarord 
  | null rovarord = []
  | checkConst (head rovarord) = head rovarord : karpsravor (drop 3 rovarord)
  | otherwise = head rovarord : karpsravor (tail rovarord)

checkVowel :: Char -> Bool
checkVowel letter = elem letter "aeiouyåäö"

checkConst :: Char -> Bool
checkConst letter = elem letter "bcdfghjklmnpqrstvwxz"
------------------end of assignment---------------------------

--------------- Lab 1 deluppgift 3. Medelvärden---------------
stripSentence :: String -> String
stripSentence [] = []
stripSentence sentence
  | isAlpha (head sentence) = head sentence : stripSentence (tail sentence)
  | otherwise = ' ' : stripSentence (tail sentence)

calculateWords :: String -> Int
calculateWords word = length (words (stripSentence word))

calculateChar :: String -> Int
calculateChar word = length ([[c] | c <- word, isAlpha c])

medellangd :: String -> Double
medellangd word = (fromIntegral (calculateChar word)) / (fromIntegral (calculateWords word))
---------------------end of assignment- -----------------------
-----------------Lab1 deluppgift 4. Listskyffling-------------

------------------------TEST----------------------------------
-- stripSentence :: String -> [String]
-- stripSentence sentence = [[x | x <- word, isAlpha x] | word <- words sentence]

-- medellangd :: String -> Double
-- medellangd sentence = fromIntegral (sum (map length (stripSentence sentence))) /
--                       fromIntegral (length (stripSentence sentence))
