module Main exposing (..)

import Browser
import Browser.Events
import Functions exposing (flip)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Decode
import Setters
import Time exposing (Posix)
import Update


{-| Got from JS side, and Model to modify
-}
type alias Flags =
    { now : Int }


type alias Snake =
    { row : Int, column : Int }


type alias Model =
    { gameStarted : Bool
    , lastUpdate : Int
    , time : Int
    , coloredSquare : Int
    , snake : List Snake
    }


init : Flags -> ( Model, Cmd Msg )
init { now } =
    now
        |> (\time ->
                Model False time time 0 [ { row = 5, column = 5 }, { row = 6, column = 5 } ]
                    |> Update.none
           )


{-| All your messages should go there
-}
type Key
    = ArrowUp
    | ArrowRight
    | ArrowDown
    | ArrowLeft
    | Space


type Msg
    = NextFrame Posix
    | ToggleGameLoop
    | KeyDown Key



-- type IntOrSnake
--     = Int Int
--     | Snake { row : Int, column : Int }


{-| Manage all your updates here, from the main update function to each
-| subfunction. You can use the helpers in Update.elm to help construct
-| Cmds.
-}
updateSquare : Model -> Model
updateSquare ({ coloredSquare } as model) =
    coloredSquare
        + 1
        |> modBy 5
        -- modBy is the operator modulo
        |> Setters.setColoredSquareIn model


updateSnake : Model -> Model
updateSnake ({ snake } as model) =
    case snake of
        [] ->
            model

        _ :: tl ->
            let
                value =
                    List.map
                        (\a ->
                            if a.row == 1 then
                                { a | row = 10 }

                            else
                                { a | row = a.row - 1 }
                        )
                        snake
            in
            { model | snake = value }


toggleGameLoop : Model -> ( Model, Cmd Msg )
toggleGameLoop ({ gameStarted } as model) =
    not gameStarted
        |> Setters.setGameStartedIn model
        |> Update.none


keyDown : Key -> Model -> ( Model, Cmd Msg )
keyDown key model =
    case Debug.log "key" key of
        Space ->
            update ToggleGameLoop model

        _ ->
            Update.none model


nextFrame : Posix -> Model -> ( Model, Cmd Msg )
nextFrame time model =
    let
        time_ =
            Time.posixToMillis time
    in
    if time_ - model.lastUpdate >= 1000 then
        -- updateSquare model
        updateSnake model
            |> Setters.setTime time_
            |> Setters.setLastUpdate time_
            |> Update.none

    else
        time_
            |> Setters.setTimeIn model
            |> Update.none


{-| Main update function, mainly used as a router for subfunctions
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleGameLoop ->
            toggleGameLoop model

        KeyDown key ->
            keyDown key model

        NextFrame time ->
            nextFrame time model


{-| Manage all your view functions here.
-}
transform : Snake -> Int
transform snakeElment =
    --(snakeElment.row - 1) * 10 + snakeElment.column
    0


cell : Int -> Int -> Html msg
cell index active =
    let
        class =
            if active == index then
                "cell active"

            else
                "cell"
    in
    Html.div [ Attributes.class class ] []



-- movingSnake : Model -> List (Html msg)
-- movingSnake model =
--     List.map (\a -> cell (transform a) model.coloredSquare) model.snake


cellSnake : Snake -> Html msg
cellSnake snake =
    let
        depRow =
            snake.row
                * 20
                |> String.fromInt

        depHeight =
            snake.column
                * 20
                |> String.fromInt
    in
    Html.div
        [ Attributes.style "position" "absolute"
        , Attributes.style "width" "20px"
        , Attributes.style "height" "20px"
        , Attributes.style "left" (depRow ++ "px")
        , Attributes.style "top" (depHeight ++ "px")
        , Attributes.class "cell"
        ]
        []


movingSnake : Model -> List (Html msg)
movingSnake { snake } =
    List.map (\a -> cellSnake a) snake



-- Html.div [] value


movingSquare : Model -> Html msg
movingSquare ({ coloredSquare } as model) =
    Html.div [ Attributes.class "grid" ]
        -- [ cell 0 coloredSquare
        -- , cell 1 coloredSquare
        -- , cell 2 coloredSquare
        -- , cell 3 coloredSquare
        -- , cell 4 coloredSquare
        -- ]
        -- [ cellSnake { row = 1, column = 5 }
        -- , cell 0 coloredSquare
        -- ]
        (movingSnake model)



--(movingSnake model)


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
    let
        word =
            if gameStarted then
                "Stop"

            else
                "Start"
    in
    Html.div [ Attributes.class "separator" ]
        [ Html.h1 []
            [ Html.text "Welcome to the snake project!" ]
        , actualTime model
        , Html.button
            [ Events.onClick ToggleGameLoop, Attributes.class "btn" ]
            [ Html.text (String.join " " [ word, "game loop" ]) ]
        ]


{-| Main view functions, composing all functions in one
-}
view : Model -> Html Msg
view model =
    Html.main_ []
        [ Html.img [ Attributes.src "/logo.svg" ] []
        , explanations model
        , movingSquare model
        ]


{-| Parts for the runtime. Get key presses and subscribe to
-| requestAnimationFrame for the game loop. You don't have to bother with
-| this.
-}
decodeArrow : String -> Decode.Decoder Key
decodeArrow value =
    case value of
        "ArrowUp" ->
            Decode.succeed ArrowUp

        "ArrowLeft" ->
            Decode.succeed ArrowLeft

        "ArrowRight" ->
            Decode.succeed ArrowRight

        "ArrowDown" ->
            Decode.succeed ArrowDown

        " " ->
            Decode.succeed Space

        _ ->
            Decode.fail "Not an arrow"


decodeKey : Decode.Decoder Msg
decodeKey =
    Decode.field "key" Decode.string
        |> Decode.andThen decodeArrow
        |> Decode.map KeyDown


subscriptions : Model -> Sub Msg
subscriptions { gameStarted } =
    let
        aF =
            Browser.Events.onAnimationFrame NextFrame

        base =
            Browser.Events.onKeyDown decodeKey :: []
    in
    Sub.batch
        (if gameStarted then
            aF :: base

         else
            base
        )


{-| Entrypoint of your program
-}
main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
