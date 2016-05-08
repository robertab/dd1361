module Evaluator where

import Parser

import Text.Parsec (ParseError)
import Text.Printf
import qualified Data.Map as M
import Control.Monad.State

type PencilState = Bool
type Pos = (Double, Double)
type Angle = Double
type Color = String
type Variables = M.Map String Int
type DrawState = (Color, Pos, Angle, Variables)

type LeoRunner = StateT (PencilState, DrawState) IO ()


evalExp :: Expr -> Variables -> Int
evalExp (Var x) v = case M.lookup x v of
                      Just n -> n
                      _ -> error "Nothing here"
evalExp (Neg (Num x)) _ = negate x
evalExp (Pos (Num x)) _ = id x
evalExp (Num x) _ = x
evalExp (Add x y) v = evalExp x v + evalExp y v
evalExp (Sub x y) v = evalExp x v - evalExp y v
evalExp (Mul x y) v = evalExp x v * evalExp y v
evalExp (Div x y) v = evalExp x v `div` evalExp y v


-- Running the leonardo instructions with StateT. Evaluating the default state
-- and running in the IO monad. 
runLeonardo :: Either ParseError [Instr] -> IO ()
runLeonardo (Right instr) = evalStateT (runInstructions instr) (False, ("0000FF", (200,300), 0, M.empty))

runInstructions :: [Instr] -> LeoRunner
runInstructions = mapM_ runInstruction 

runInstruction :: Instr -> LeoRunner
runInstruction Up = modify (\(_,state) -> (False, state))
runInstruction Down = modify (\(_,state) -> (True, state))
runInstruction (Forw exp) = do
 (pstate, (c, (x,y), a, v)) <- get
 put (pstate, (c ,((newx x a v), (newy y a v)), a, v))
 (pstate, (c, newpos, a, v)) <- get
 liftIO $ drawPicture pstate (x,y) newpos c
  where newx x a v = (x + cos a * (fromIntegral (evalExp exp v)*50))
        newy y a v = (y + sin a * (fromIntegral (evalExp exp v)*50)) 
runInstruction (Back exp) = do
 (pstate, (c, (x,y), a, v)) <- get
 put (pstate, (c ,((newx x a v), (newy y a v)), a, v))
 (pstate, (c, newpos, a, v)) <- get
 liftIO $ drawPicture pstate (x,y) newpos c
  where newx x a v = (x - cos a * (fromIntegral (evalExp exp v)*50))
        newy y a v = (y - sin a * (fromIntegral (evalExp exp v)*50)) 
runInstruction (LeftI exp) = modify (\(p, (c, pos, a, v)) -> (p, (c, pos, newangle a v, v)))
  where newangle angle v = angle - pi * (fromIntegral (evalExp exp v) / 180)
runInstruction (RightI exp) = modify (\(p, (c, pos, a, v)) -> (p, (c, pos, newangle a v, v)))
  where newangle angle v = angle + pi * (fromIntegral (evalExp exp v) / 180)
runInstruction (Color code) = do
  (pstate, (c, pos, a, v)) <- get
  put (pstate, (code, pos, a, v))
runInstruction (Rep exp i) = do
  (_, (_, _, _, v)) <- get
  loop (evalExp exp v)
  where loop 0 = return ()
        loop n = runInstruction i >> loop (n-1)
runInstruction (MRep exp is) = do
  (_, (_, _, _, v)) <- get
  loop (evalExp exp v)
  where loop 0 = return ()
        loop n = mapM_ runInstruction is >> loop (n-1)
runInstruction (variable := expr) = do
  (pstate, (c, pos, a ,v)) <- get 
  let newval = evalExp expr v
      newvar = M.insert variable newval v
  put (pstate, (c, pos, a, newvar))
  return ()

drawPicture False _ _ _ = return ()
drawPicture True (x1, y1) (x2, y2) color = 
  printf format x1 y1 x2 y2 color

format :: String
format = "<line x1=\"%.4f\" y1=\"%.4f\" x2=\"%.4f\" y2=\"%.4f\" stroke=\"#%s\" />\n"



