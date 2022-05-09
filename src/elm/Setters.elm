module Setters exposing (..)

import Functions exposing (flip)

setTime : b -> { a | time : b } -> { a | time : b }
setTime time record = { record | time = time }

setTimeIn : { a | time : b } -> b -> { a | time : b }
setTimeIn = flip setTime

setGameStarted : b -> { a | gameStarted : b } -> { a | gameStarted : b }
setGameStarted gameStarted record = { record | gameStarted = gameStarted }

setGameStartedIn : { a | gameStarted : b } -> b -> { a | gameStarted : b }
setGameStartedIn = flip setGameStarted

setColoredSquare : b -> { a | coloredSquare : b } -> { a | coloredSquare : b }
setColoredSquare coloredSquare record = { record | coloredSquare = coloredSquare }

setColoredSquareIn : { a | coloredSquare : b } -> b -> { a | coloredSquare : b }
setColoredSquareIn = flip setColoredSquare

setLastUpdate : b -> { a | lastUpdate : b } -> { a | lastUpdate : b }
setLastUpdate lastUpdate record = { record | lastUpdate = lastUpdate }

setLastUpdateIn : { a | lastUpdate : b } -> b -> { a | lastUpdate : b }
setLastUpdateIn = flip setLastUpdate
