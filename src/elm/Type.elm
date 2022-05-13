module Type exposing (..)

type Key = ArrowUp | ArrowRight | ArrowDown | ArrowLeft | Space | Neutral

type alias Model =
  { gameStarted : Bool
  , lastUpdate : Int
  , time : Int
  , coloredSquare : Int
  , direction : Key
  , bonus : Int
  , score : Int 
  }
