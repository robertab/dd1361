data Tree a = Leaf | Node a (Tree a) (Tree a) deriving (Show, Eq)



traverseBF :: Tree a -> [a]
traverseBF tree = tbf [tree]
    where
        tbf [] = []
        tbf xs = map nodeValue xs ++ tbf (concat (map leftAndRightNodes xs))
        nodeValue (Node a _ _) = a
        leftAndRightNodes (Node _ Leaf Leaf) = []
        leftAndRightNodes (Node _ Leaf b)    = [b]
        leftAndRightNodes (Node _ a Leaf)    = [a]
        leftAndRightNodes (Node _ a b)       = [a,b]


traverseDF :: Tree a -> [a]
traverseDF Leaf        = []
traverseDF (Node a l r) = a : (traverseDF l) ++ (traverseDF r)

createTree = Node '-'
                (Node 'o'
                    (Node 'o' Leaf Leaf)
                    (Node '-' Leaf Leaf)
                )
                (Node '-'
                    (Node '-' Leaf Leaf)
                    (Node '-' Leaf (Node '-'
                        (Node '-' Leaf Leaf)
                        Leaf
                    ))
                )
