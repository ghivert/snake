module Main exposing (..)

import Browser
import Browser.Events
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events exposing (onClick)
import Time exposing (Posix)
import Setters
import Update
import Type exposing (..)
import Direction exposing (..)
import Json.Decode as Decode

{- interdire linput de lutilisateur dans la direction vers le bas -}

{-| Got from JS side, and Model to modify -}
type alias Flags = { now : Int }

init : Flags -> ( Model, Cmd Msg )
init { now } =
  now
  |> \time -> Model False time time 0 Neutral 20 0
  |> Update.none

{-| All your messages should go there -}
type Msg
  = NextFrame Posix
  | ToggleGameLoop
  | KeyDown Key

{-| Manage all your updates here, from the main update function to each
 -|   subfunction. You can use the helpers in Update.elm to help construct
 -|   Cmds. -}
updateSquare : Model -> Model
updateSquare ({ coloredSquare } as model) =
  coloredSquare + 1
  |> modBy 4
  |> Setters.setColoredSquareIn model

toggleGameLoop : Model -> ( Model, Cmd Msg )
toggleGameLoop ({ gameStarted } as model) =
  not gameStarted
  |> Setters.setGameStartedIn model
  |> Update.none

changeDirection: Key -> Model -> Model
changeDirection newDdirection model =
  { model | direction = newDdirection }

keyDown : Key -> Model -> ( Model, Cmd Msg )
keyDown key model =
  case Debug.log "key" key of
    Space -> update ToggleGameLoop model
    -- utiliser la boucle ciclyque pour continuer a bouger le snake
    ArrowLeft -> Update.none (changeDirection ArrowLeft model)
    ArrowRight -> Update.none (changeDirection ArrowRight model)
    ArrowUp -> Update.none (changeDirection ArrowUp model)
    _ -> Update.none model

nextFrame : Posix -> Model -> ( Model, Cmd Msg )
nextFrame time model =
  let time_ = Time.posixToMillis time in
  if time_ - model.lastUpdate >= 1000 then
    updateSquare model
    |> Setters.setTime time_
    |> Setters.setLastUpdate time_
    |> Update.none
  else
    time_
    |> Setters.setTimeIn model
    |> Update.none

{-| Main update function, mainly used as a router for subfunctions -}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  -- let msgDebug = Debug.log "keyPress" msg in
  case msg of
    ToggleGameLoop -> toggleGameLoop model
    KeyDown key -> keyDown key model
    NextFrame time -> nextFrame time model

{-| Manage all your view functions here. -}
cell : Int -> Int -> Html msg
cell index active =
  let class = if active == index then "cell red-active" else "cell" in
  Html.div [ Attributes.class class ] []


movingSquare : Model -> Html msg
movingSquare { coloredSquare, direction } =
  Html.div [][
    Html.div [ Attributes.class "grid" ][
      moveDirection direction
    ]
    , Html.div [ Attributes.class "grid-wide" ]
      [ cell 0 coloredSquare
      , cell 1 1
      , cell 3 3
      , cell 2 coloredSquare
      , cell 2 coloredSquare
      , cell 1 coloredSquare
      , cell 3 coloredSquare
      , cell 2 coloredSquare
      , cell 2 coloredSquare
      , cell 2 coloredSquare
      , cell 1 coloredSquare
      , cell 3 coloredSquare
      , cell 2 coloredSquare
      , cell 2 coloredSquare
      , cell 2 coloredSquare
      , cell 1 coloredSquare
      , cell 3 coloredSquare
      , cell 2 coloredSquare
      , cell 1 coloredSquare
      , cell 3 coloredSquare
      ]
  ]

actualTime : Model -> Html msg
actualTime { time } =
  Html.div [ Attributes.class "actual-time" ]
    [ Html.text "Actual time"
    , time
      |> String.fromInt
      |> Html.text
      |> List.singleton
      |> Html.code []
    ]

explanations : Model -> Html Msg
explanations ({ gameStarted } as model) =
  let word = if gameStarted then "Stop" else "Start" in
  Html.div [ Attributes.class "separator" ]
    [ Html.h1 []
      [ Html.text "SNAKE !!!!!" ]
    , actualTime model
    , Html.button
      [ Events.onClick ToggleGameLoop, Attributes.class "btn" ]
      [ Html.text (String.join " " [word, "game loop"]) ]
    ]

-- score: Model -> Html Msg

{-| Main view functions, composing all functions in one -}
view : Model -> Html Msg
view model =
  Html.main_ []
    [ Html.img [ Attributes.src "/logo.svg" ] []
    , explanations model
    -- , score model
    , Html.div [ onClick (KeyDown ArrowRight) ][Html.button [][Html.text "Move left"]
      , Html.button [][Html.text "Move right"]
      ]
    , movingSquare model
    ]

{-| Parts for the runtime. Get key presses and subscribe to
 -|   requestAnimationFrame for the game loop. You don't have to bother with
 -|   this. -}
decodeArrow : String -> Decode.Decoder Key
decodeArrow value =
  case value of
    "ArrowUp" -> Decode.succeed ArrowUp
    "ArrowLeft" -> Decode.succeed ArrowLeft
    "ArrowRight" -> Decode.succeed ArrowRight
    "ArrowDown" -> Decode.succeed ArrowDown
    " " -> Decode.succeed Space
    _ -> Decode.fail "Not an arrow"

decodeKey : Decode.Decoder Msg
decodeKey =
  Decode.field "key" Decode.string
  |> Decode.andThen decodeArrow
  |> Decode.map KeyDown

subscriptions : Model -> Sub Msg
subscriptions { gameStarted } =
  let aF = Browser.Events.onAnimationFrame NextFrame
      base = Browser.Events.onKeyDown decodeKey :: [] in
    Sub.batch (if gameStarted then aF :: base else base)

{-| Entrypoint of your program -}
main : Program Flags Model Msg
main =
  Browser.element
    { view = view
    , init = init
    , update = update
    , subscriptions = subscriptions
    }
