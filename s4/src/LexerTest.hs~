module LexerTest where

import Control.Applicative ((<*))
import Text.Parsec
import Text.Parsec.String
import Text.Parsec.Expr
import Text.Parsec.Token
import Text.Parsec.Language







data Instr = Rep Expr Instr
             | Var = String
             | Forw Expr
  deriving (Show, Eq)

data Expr = Const Int
          | Var String
          | Add Expr Expr
  deriving (Show, Eq)
  
             
