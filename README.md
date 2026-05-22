# Lógica Computacional 2026-2

## Práctica 5

Para trabajar sobre esta base, tienen que hacer un fork de este repositorio y trabajar sobre él.

Únicamente modifiquen el archivo Practica05.hs que se encuentra en el directorio src. Si quieren modificar las pruebas o agregar más, pueden preguntarme con confianza y les explico como modificarlas.

Deben tener instalado el compilador de Haskell para poder probar su práctica. Para ello deben colocarse en el directorio src y ejecutar el comando `ghci Practica05.hs`.

Si quieren probar su práctica haciendo uso de las pruebas unitarias que les estoy pasando, tienen que ejecutar los siguientes comandos desde el directorio donde se encuentra este ReadMe:
```
cabal build
cabal test
```

El primero es para compilar y el segundo es para ejecutar las pruebas unitarias.

Si no les llegan a funcionar, es posible que el problema es que tengan una versión diferente de cabal y de ghc. Si ese es el caso, pueden ejecutar el comando `ghc-pkg list base` para reemplazar la versión base que viene en el archivo .cabal en las líneas 70 y 102.

## Integrantes
+ Vazquez Merino Lenin Quetzal
    - No. de Cuenta: 425106914 
+ Islas Garcia Fernando
    - No. de Cuenta: 32229531 

## Comentarios

Para las dos ultimas funciones use map y concatMap, para ello hice mi propia implementación, además investigue acerca de la funcion return que tiene que ver algo con el cotexto de una monada, se me hizo algo interesenta como funciona, ademas vi que aplicado a contexto de listas, se puede usar para hacer unificaListas o unificaConj haciendo un uso de un do, sin embargo, se me hizo algo compleja de implemetar, pues de Monadas solo conozco Mybe, donde se usa nothing y just, que suele usarse para manejar errores.