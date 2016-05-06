module Parse where

import S4

--data Tree a b = Next a b (Tree a b)| Branch a b (Tree a b) | Empty deriving (Show)
data Tree a b = Node a b (Tree a b) (Tree a b) | Leaf deriving (Show, Eq)


-- parseTokens (Right [])                         = Empty
-- parseTokens (Right (Down:Dot:ts))              = Next Down 0 (parseTokens (Right ts)) 
-- parseTokens (Right (Up:Dot:ts))                = Next Up 0 (parseTokens (Right ts))
-- parseTokens (Right (Color:(Hash code):Dot:ts)) = Next (Hash code) 0 (parseTokens (Right ts))
-- parseTokens (Right (Forw:(Num x):Dot:ts))      = Next (Forw) x (parseTokens (Right ts))
-- parseTokens (Right (Back:(Num x):Dot:ts))      = Next (Back) x (parseTokens (Right ts))
-- parseTokens (Right (LeftI:(Num x):Dot:ts))     = Next (LeftI) x (parseTokens (Right ts))
-- parseTokens (Right (RightI:(Num x):Dot:ts))    = Next (RightI) x (parseTokens (Right ts))
-- parseTokens (Right (Rep:(Num x):Quote:ts))     = Next ()     --(Branch Rep x (parseTokens (Right ts))
-- parseTokens (Right (Rep:(Num x):ts))           = Branch --(Rep x (parseTokens (Right ts)))
-- parseTokens (Right (Quote:ts))                 = parseTokens (Right ts)
-- parseTokens _ = Empty



-- Node Rep x (parseTokens t (Right ts)) t


parseTokens :: Tree Token Integer -> Either e [Token] ->  Tree Token Integer
parseTokens Leaf (Right []) = Leaf 
parseTokens t (Right (Down:Dot:ts)) = Node Down 0 Leaf (parseTokens t (Right ts))
parseTokens t (Right (Up:Dot:ts)) = Node Up 0 Leaf (parseTokens t (Right ts))
parseTokens t (Right (Forw:(Num x):Dot:ts)) = Node Forw x Leaf (parseTokens t (Right ts))
parseTokens t (Right (RightI:(Num x):Dot:ts)) = Node RightI x Leaf (parseTokens t (Right ts))
parseTokens t (Right (LeftI:(Num x):Dot:ts)) = Node LeftI x Leaf (parseTokens t (Right ts))
parseTokens t (Right (Back:(Num x):Dot:ts)) = Node Back x Leaf (parseTokens t (Right ts))
parseTokens t (Right (Color:(Hash code):Dot:ts)) = Node (Hash code) 0 Leaf (parseTokens t (Right ts))
parseTokens t (Right (Rep:(Num x):Quote:ts)) = Node Rep x (parseTokens t (Right ts)) (parseTokens t (Right ts))
parseTokens t (Right (Rep:(Num x):ts)) = case ts of
                                           (instr:num:dot:ts') -> Node Rep x (parseTokens t (Right ([instr]++[num]++[dot]))) (parseTokens t (Right ts'))
                                           (instr:dot:ts') -> Node Rep x (parseTokens t (Right ([instr]++[dot]))) (parseTokens t (Right ts'))
parseTokens t (Right (Quote:ts)) = Leaf
