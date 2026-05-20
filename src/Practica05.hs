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
quitaSimilares _ [] = []
quitaSimilares (x:xs) (y:ys) 
    | esSimilar (x:xs) y = quitaSimilares (x:xs) ys
    | otherwise = y : quitaSimilares (x:xs) ys

esSimilar :: Subst -> (Nombre, Term) -> Bool
esSimilar [] _ = False 
esSimilar ((n,t):xs) (m,v) = n == m || (esSimilar xs (m,v))

--Funcion que devuelve un umg de dos terminos, si es que lo hay
unifica :: Term -> Term -> [Subst]
unifica = undefined


--Funcion que devuelve un unificador de dos términos funcionales, si es que lo hay
unificaListas :: [Term] -> [Term] -> [Subst]
unificaListas = undefined

--Funcion que devuelve un umg de una lista de termino, si es que lo hay
unificaConj :: [Term] -> [Subst]
unificaConj = undefined

