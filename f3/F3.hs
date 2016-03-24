{-
Författare: Robert Åberg, Sara Ervik
Uppgfift:   F3, Evolutionära träd och I/O
Kurs:       DD1361, Funktionell programmering
-}


module F3 where

import           Data.List

---------------- DECLARING TYPES AND CLASSES--------------------------------

data Mol = DNA | Protein deriving (Show, Eq)

data MolSeq = MolSeq { molename :: String
                     , sqnce    :: String
                     , mol      :: Mol
                     } deriving (Show, Eq)

data Profile = Profile { profilename   :: String
                      , matrix         :: [[(Char, Double)]]
                      , sequenceamount :: Int
                      , mole           :: Mol} deriving (Show, Eq)

class Evol a where
  name :: a -> String
  distance :: a -> a -> Double
  moltype :: a -> Mol
  distanceMatrix :: [a] -> [(String, String, Double)]
  distanceMatrix [] = []
  distanceMatrix list = [(name x, name y, if name x == name y then 0 else distance x y) | y <- list] ++ distanceMatrix (tail list)
   where x = head list


instance Evol Profile where
  name = profilename
  distance = profileDistance
  moltype = mole

instance Evol MolSeq where
  name = molename
  distance = seqDistance
  moltype = mol

---------------END OF TYPE/CLASS DECLARATION-------------------------------

string2seq :: String -> String -> MolSeq
string2seq aname sqnc
  | elem True [True | x <- sqnc, notElem x "ACGT"] = MolSeq aname sqnc Protein
  | otherwise = MolSeq aname sqnc DNA

seqName :: MolSeq -> String
seqName (MolSeq molname _ _) = molname-- returnerar nameet på dna/protein

seqSequence :: MolSeq -> String -- returnerar seqen
seqSequence (MolSeq _ sqnc _) = sqnc

seqLength :: MolSeq -> Int -- returnerar längden av seqen
seqLength (MolSeq _ sqnc _) = length sqnc

seqType :: MolSeq -> Mol
seqType (MolSeq _ _ amol) = amol

seqDistance :: MolSeq -> MolSeq -> Double
seqDistance type1 type2
  | mol type1 /= mol type2 = error "Different type"
  | alpha > 0.74 && mol type1 == DNA = 3.3
  | alpha > 0.94 && mol type1 == Protein = 3.7
  | mol type1 == DNA = -0.75 * log (1 - 4*alpha/3)
  | mol type2 == Protein = -19/20 * log (1 - 20 * alpha / 19)
  where alpha = fromIntegral (length [(x,y) | (x,y) <- (zip (seqSequence type1) (seqSequence type2)), x/=y]) /
                fromIntegral (length (seqSequence type1))


molseqs2profile :: String -> [MolSeq] -> Profile
molseqs2profile aname type1 = Profile aname (makeProfileMatrix type1) (length type1) (mol (head type1))

nucleotides = "ACGT"
aminoacids = sort "ARNDCEQGHILKMFPSTWYVX"
makeProfileMatrix :: [MolSeq] -> [[(Char,Double)]]
makeProfileMatrix [] = error "Empty sequencelist"
makeProfileMatrix sl = res
    where
      t = seqType (head sl) -- Första Molseq i [MolSeq]
      defaults =
          if (t == DNA) then zip nucleotides (replicate (length nucleotides) 0) -- Fyller en kolumn med nollor om DNA
          else
              zip aminoacids (replicate (length aminoacids) 0) -- Fyller en kolumn om det är Proteiner
      strs = map seqSequence sl
      tmpl = map (map (\x -> ((head x), (fromIntegral(length x)/fromIntegral(length strs)))) . group . sort)
             (transpose strs) -- Vänder på listan för att kunna sortera och jämföra listan
      equalFst a b = (fst a) == (fst b)
      res = map sort (map  (\l -> unionBy equalFst l defaults) tmpl)


profileName :: Profile -> String
profileName prof = profilename prof

profileFrequency :: Profile -> Int -> Char -> Double
profileFrequency prof pos char = (head [y | (x, y) <- (matrix prof) !! pos, x == char])

profileDistance :: Profile ->  Profile -> Double
profileDistance prof1 prof2 = sum [abs(x-y) | (x,y) <- zip matrix1 matrix2]
    where
      matrix1 = [snd x | xs <- matrix prof1, x <- xs]
      matrix2 = [snd y | ys <- matrix prof2, y <- ys]


main :: IO ()
main = putStrLn "Hello, world"

