module Explorer exposing (main)

import Html exposing (..)
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        , storiesOf
        )


main : UIExplorerProgram {} () {} ()
main =
    explore
        defaultConfig
        [ storiesOf
            "Welcome"
            [ ( "Default", \_ -> text "Welcome to you explorer.", {} )
            ]
        ]
