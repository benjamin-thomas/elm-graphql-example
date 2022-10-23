module Explorer exposing (main)

import Html exposing (div)
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
            [ ( "Default", \_ -> Html.text "Welcome to you explorer.", {} )
            ]
        ]
