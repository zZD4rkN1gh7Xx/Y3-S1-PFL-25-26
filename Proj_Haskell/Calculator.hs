
{-# OPTIONS_GHC -w #-} -- so para nao ter os squiggles no vscode ja que vai haver sempre alguns anyways

{-
  A basic calculator for arithmetic expressions
  Based on the example in Chapter 8 of "Programming in Haskell"
  by Graham Hutton.

  Pedro Vasconcelos, 2025
-}
module Main where

import Parsing ( Parser, parse, (<|>), satisfy, char, many1 )
import Data.Char (isDigit, isAlpha)


type Env = [(String, Integer)] -- will be the type of the global variable library

-- library function:
lookUpVar :: String -> Env -> Integer
lookUpVar name [] = error ("Variable " ++ name ++ " not found")
lookUpVar name ((var, val):rest) 
  | name == var = val
  | otherwise = lookUpVar name rest

updateEnv :: String -> Integer -> Env -> Env
updateEnv name value [] = [(name, value)]
updateEnv name value ((var, val):rest)
  | name == var = (var, value) : rest
  | otherwise = (var, val) : updateEnv name value rest

--
-- a data type for expressions
-- made up from integer numbers, + and *
--
data Expr = Num Integer | Var String
          | Add Expr Expr | Sub Expr Expr
          | Mul Expr Expr | Div Expr Expr | Mod Expr Expr
          deriving Show
      
data Comand = Assign String Expr | Eval Expr
            deriving Show

-- a recursive evaluator for expressions
--
eval :: Env -> Expr -> Integer
eval _ (Num n) = n
eval env (Var n) = lookUpVar n env
eval env (Add e1 e2) = eval env e1 + eval env e2
eval env (Sub e1 e2) = eval env e1 - eval env e2
eval env (Mul e1 e2) = eval env e1 * eval env e2
eval env (Div e1 e2) = div (eval env e1) (eval env e2)
eval env (Mod e1 e2) = mod (eval env e1) (eval env e2)


-- | a parser for expressions
-- Grammar rules:
--
-- expr ::= term exprCont
-- exprCont ::= '+' term exprCont | epsilon

-- term ::= factor termCont
-- termCont ::= '*' factor termCont | epsilon

-- factor ::= natural | '(' expr ')'

expr :: Parser Expr
expr = do t <- term
          exprCont t

exprCont :: Expr -> Parser Expr
exprCont acc = do char '+'
                  t <- term
                  exprCont (Add acc t)
               <|>
               do char '-'
                  t <- term
                  exprCont (Sub acc t)   
               <|> return acc
              
term :: Parser Expr
term = do f <- factor
          termCont f

termCont :: Expr -> Parser Expr
termCont acc =  do char '*'
                   f <- factor  
                   termCont (Mul acc f)
                 <|>
                do char '/'
                   f <- factor
                   termCont (Div acc f)
                 <|>
                do char '%'
                   f <- factor
                   termCont (Mod acc f)   
                 <|> return acc

factor :: Parser Expr
factor = do n <- natural
            return (Num n)
          <|>
         do v <- varriable
            return (Var v)
          <|>
          do char '('
             e <- expr
             char ')'
             return e

command :: Parser Comand
command = do v <- varriable
             char '='
             e <- expr
             return (Assign v e)
          <|>
          do e <- expr
             return (Eval e)    
             

natural :: Parser Integer
natural = do xs <- many1 (satisfy isDigit)
             return (read xs)

varriable :: Parser String
varriable = do xs <- many1 (satisfy isAlpha)
               return xs

----------------------------------------------------------------             
  
main :: IO ()
main
  = do txt <- getContents --single time use, need to restart ghci afterwards
       calculator [] (lines txt)

-- | read-eval-print loop
calculator :: Env -> [String] -> IO ()
calculator _ []  = return ()
calculator _ ("quit":rest) = return ()
calculator env (l:ls) = do 
                      let (out, new_env) = evaluate env l
                      putStrLn out
                      calculator new_env ls  

-- | evaluate a single expression
evaluate :: Env -> String -> (String, Env)
evaluate env txt =
  case parse command txt of
    [(Assign var expression, "")] ->
      let val  = eval env expression
          env' = updateEnv var val env
      in (show val, env')

    [(Eval expression, "")] ->
      (show (eval env expression), env)            

    _ -> ("parse error; try again", env)  
