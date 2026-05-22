module Practica05 where

import Terminos

--Aplicar una sustitucion a un termino
apsubT :: Term -> Subst -> Term
apsubT term [] = term
apsubT (Var p) ((n,t):xs) 
    | p == n = t
    | otherwise = apsubT (Var p) xs
apsubT (Fun p terms) sust = (Fun p (aplicarLista terms sust) )


--Funcion auxiliar para aplicar la sustitucion a una lista de terminos
aplicarLista :: [Term] -> Subst -> [Term]
aplicarLista [] _ = []
aplicarLista (x:xs) subst = (apsubT x subst) : (aplicarLista xs subst)

--Funcion que elimina los pares que son de la forma x=x
simpSus :: Subst -> Subst
simpSus [] = []
simpSus ((n,(Var p)):xs) 
    | n == p = simpSus xs
    | otherwise = (n,(Var p)): (simpSus xs)
simpSus ((n,t):xs) =  (n,t) : (simpSus xs)


--Funcion que calcula la composicion de dos sustituciones
compSus :: Subst -> Subst -> Subst
compSus rho0 tau0 =
    let x = simpSus (aplicaSust rho0 tau0)
    in x ++ (quitaSimilares x tau0)

aplicaSust :: Subst -> Subst -> Subst
aplicaSust [] _ = []
aplicaSust ((n,t):xs) tau0 = (n, apsubT t tau0) : aplicaSust xs tau0

quitaSimilares :: Subst -> Subst -> Subst 
quitaSimilares _ [] = []                          -- Segunda lista vacía
quitaSimilares [] (y:ys) = y : quitaSimilares [] ys  -- Primera lista vacía
quitaSimilares (x:xs) (y:ys)                      -- Ambas no vacías
    | esSimilar (x:xs) y = quitaSimilares (x:xs) ys
    | otherwise = y : quitaSimilares (x:xs) ys

esSimilar :: Subst -> (Nombre, Term) -> Bool
esSimilar [] _ = False 
esSimilar ((n,t):xs) (m,v) = n == m || (esSimilar xs (m,v))

--Funcion que devuelve un umg de dos terminos, si es que lo hay
unifica :: Term -> Term -> [Subst]
unifica t1 t2 = case (t1, t2) of
-- Caso donde son constantes
  (Fun a [], Fun b []) -> 
    if a == b then [[]]
    else []
  -- Caso donde algun termino es una variable
  (Var x, Var y) | x==y -> [[]]
  (Var x, t) -> if ocurre x t then []
    else  [[(x,t)]]
  (t, Var x) -> if ocurre x t then []
    else [[(x,t)]]
  -- Caso donde los terminos son funcionales
  (Fun f1 arg1, Fun f2 arg2) -> 
    if f1==f2 && long arg1 == long arg2 then unificaListas arg1 arg2
    else []
  
long :: [a] -> Int
long [] = 0 
long (x:xs) = 1 + long xs
  
ocurre :: String -> Term -> Bool
-- Caso 1: Si el término es una variable, verificamos si es la misma que buscamos
ocurre x (Var y) = x == y

-- Caso 2: Si es una función, tenemos que revisar recursivamente si la variable 
--         "ocurre" en cualquiera de los términos de su lista de argumentos.
ocurre x (Fun _ args) = any (ocurre x) args

-- Función auxiliar para procesar lista de sustituciones
procesarSustituciones :: [Subst] -> ([Term] -> [Term] -> [Subst]) -> [Term] -> [Term] -> [Subst]
procesarSustituciones [] _ _ _ = []
procesarSustituciones (susta:resto) f ss rr = 
    let resultados = miMap (\sustb -> compSus susta sustb) (f ss rr)
    in resultados ++ procesarSustituciones resto f ss rr
    
--Funcion que devuelve un unificador de dos términos funcionales, si es que lo hay
unificaListas :: [Term] -> [Term] -> [Subst]
unificaListas [] [] = [[]]
unificaListas (s:ss) (r:rr) = 
    miConcatMap (\susta -> 
        miMap (\sustb -> compSus susta sustb) 
              (unificaListas (aplicarLista ss susta) (aplicarLista rr susta))
    ) (unifica s r)
unificaListas _ _ = []

    
{-
unificaListas :: [Term] -> [Term] -> [Subst]
unificaListas [] [] = [[]]
unificaListas (s:ss) (r:rr) = do
    susta <- unifica s r
    sustb <- unificaListas (aplicarLista ss susta) (aplicarLista rr susta)
    return (compSus susta sustb)
unificaListas _ _ = []
-}
-- Implementación de map
miMap :: (a -> b) -> [a] -> [b]
miMap _ [] = []
miMap f (x:xs) = f x : miMap f xs

-- Implementación de concatMap
miConcatMap :: (a -> [b]) -> [a] -> [b]
miConcatMap _ [] = []
miConcatMap f (x:xs) = f x ++ miConcatMap f xs

--Funcion que devuelve un umg de una lista de termino, si es que lo hay
unificaConj :: [Term] -> [Subst]
unificaConj [] = [[]]
unificaConj [t] = [[]]  -- Un solo término siempre es unificable
unificaConj (t1:t2:ts) = 
    miConcatMap (\susta -> 
        miMap (\sustb -> compSus susta sustb) 
              (unificaConj (aplicarLista (t1:ts) susta))
    ) (unifica t1 t2)

