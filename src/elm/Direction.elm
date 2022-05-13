module Direction exposing (..)

import Type exposing (..)
import Html exposing (Html)
import Html.Attributes as Attributes

moveDirectionHelp : Key -> String
moveDirectionHelp direction =
  case direction of
    ArrowLeft -> "cell red-active anim-moveLeft"
    ArrowRight -> "cell red-active anim-moveRight"
    _ -> ""

moveDirection : Key -> Html msg
moveDirection direction =
  let class = moveDirectionHelp direction in
  Html.div [ Attributes.class class ] []
