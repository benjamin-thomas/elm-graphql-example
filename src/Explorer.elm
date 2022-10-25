module Explorer exposing (main)

import Html exposing (text)
import UI.Button
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
        , storiesOf
            "Buttons"
            [ ( "Primary", \_ -> UI.Button.primary "OK!", {} )
            , ( "Default", \_ -> UI.Button.default "Click me!", {} )
            , ( "Danger", \_ -> UI.Button.danger "Delete me!", {} )
            ]
        ]
