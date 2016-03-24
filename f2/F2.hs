module F2 where

{-
Författare: Robert Åberg, Sara Ervik
Uppgfift:   F2, Molekylärbiologi i Haskell
Kurs:       DD1361, Funktionell programmering
-}


import           Data.List

---------------- DECLARING TYPES AND CLASSES--------------------------------

data Mol
  = DNA
  | Protein
  deriving (Show,Eq)

data MolSeq =
  MolSeq {seqName     :: String
         ,seqSequence :: String
         ,seqType     :: Mol}
  deriving (Show,Eq)

data Profile =
  Profile {profileName    :: String
          ,matrix         :: [[(Char,Double)]]
          ,sequenceAmount :: Int
          ,profType       :: Mol}
  deriving (Show,Eq)

class Evol a  where
  name :: a -> String
  distance :: a -> a -> Double
  molType :: a -> Mol
  distanceMatrix
    :: [a] -> [(String,String,Double)]
  distanceMatrix [] = []
  distanceMatrix seqlist@(x:xs) =
    [(name x,name y,distance x y) | y <- seqlist] ++ distanceMatrix xs

instance Evol Profile where
  name = profileName
  distance = profileDistance
  molType = profType

instance Evol MolSeq where
  name = seqName
  distance = seqDistance
  molType = seqType

---------------END OF TYPE/CLASS DECLARATION-------------------------------

string2seq :: String -> String -> MolSeq
string2seq seqname sq
  | isProtein sq = MolSeq seqname sq Protein
  | otherwise = MolSeq seqname sq DNA
  where isProtein = any (`notElem` nucleotides)

seqLength :: MolSeq -> Int
seqLength (MolSeq _ sqnc _) = length sqnc

seqDistance :: MolSeq -> MolSeq -> Double
seqDistance type1 type2
  | seqType type1 /= seqType type2 = error "Different types"
  | alpha > 0.74 && seqType type1 == DNA = 3.3
  | alpha > 0.94 && seqType type1 == Protein = 3.7
  | seqType type1 == DNA = (-0.75) * log (1 - 4 * alpha / 3)
  | seqType type2 == Protein = (-19) / 20 * log (1 - 20 * alpha / 19)
  where alpha =
          fromIntegral $
          (length $
           filter (\(x,y) -> x /= y) $
           zip (seqSequence type1)
               (seqSequence type2)) `div`
          (length (seqSequence type1))

molseqs2profile :: String -> [MolSeq] -> Profile
molseqs2profile profName seqs@(x:_) =
  Profile profName
          (makeProfileMatrix seqs)
          (length seqs)
          (seqType x)

nucleotides :: [Char]
nucleotides = "ACGT"

aminoacids :: [Char]
aminoacids = sort "ARNDCEQGHILKMFPSTWYVX"

makeProfileMatrix :: [MolSeq] -> [[(Char,Double)]]
makeProfileMatrix [] = error "Empty sequencelist"
makeProfileMatrix sl@(s:ss) = res
  where t = seqType s -- Första Molseq i [MolSeq]
        defaults =
          if (t == DNA)
             then zip nucleotides (replicate (length nucleotides) 0) -- Fyller en kolumn med nollor om DNA
             else zip aminoacids (replicate (length aminoacids) 0) -- Fyller en kolumn om det är Proteiner
        strs = map seqSequence sl
        tmpl =
          map (map (\x ->
                      ((head x)
                      ,(fromIntegral (length x) / fromIntegral (length strs)))) .
               group . sort)
              (transpose strs) -- Vänder på listan för att kunna sortera och jämföra listan
        equalFst a b = (fst a) == (fst b)
        res = map sort (map (\l -> unionBy equalFst l defaults) tmpl)


profileFrequency :: Profile -> Int -> Char -> Double
profileFrequency prof pos c =
  snd . head . filter (\(x,_) -> x == c) $ (matrix prof) !! pos

profileDistance :: Profile -> Profile -> Double
profileDistance prof1 prof2 = sum [abs (x - y) | (x,y) <- zip matrix1 matrix2]
  where matrix1 =
          [snd x | xs <- matrix prof1
                 , x <- xs]
        matrix2 =
          [snd y | ys <- matrix prof2
                 , y <- ys]
