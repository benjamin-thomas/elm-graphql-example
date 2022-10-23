module UI.Button exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)


primary : String -> Html msg
primary txt =
    button [ style "background-color" "lightblue" ] [ text txt ]


default : String -> Html msg
default txt =
    button [ style "background-color" "lightgrey" ] [ text txt ]


danger : String -> Html msg
danger txt =
    button [ style "background-color" "red" ] [ text txt ]
