module Main exposing (..)

import Browser
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (..)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))
import StarWars.Object
import StarWars.Object.Human as Human
import StarWars.Query as Query
import StarWars.Scalar exposing (Id(..))



{-
      import Graphql.Operation exposing (RootQuery)
      import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
      import StarWars.Object
      import StarWars.Object.Human as Human
      import StarWars.Query as Query
      import StarWars.Scalar exposing (Id(..))


      query : SelectionSet (Maybe HumanData) RootQuery
      query =
          Query.human { id = Id "1001" } humanSelection


      type alias HumanData =
          { name : String
          , homePlanet : Maybe String
          }


      humanSelection : SelectionSet HumanData StarWars.Object.Human
      humanSelection =
          SelectionSet.map2 HumanData
              Human.name
              Human.homePlanet


   makeRequest : Cmd Msg
   makeRequest =
       query
           |> Graphql.Http.queryRequest "https://elm-graphql.herokuapp.com"
           |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)
-}


type alias HumanData =
    { name : String
    , homePlanet : Maybe String
    }


query : String -> SelectionSet (Maybe HumanData) RootQuery
query n =
    Query.human { id = Id n }
        humanSelection


humanSelection : SelectionSet HumanData StarWars.Object.Human
humanSelection =
    SelectionSet.map2 HumanData Human.name Human.homePlanet


type Msg
    = ClickedLoadData String
    | GotResponse Model


type alias Response =
    Maybe HumanData



-- Character


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


fetchData : String -> Cmd Msg
fetchData n =
    query n
        |> Graphql.Http.queryRequest "https://elm-graphql.herokuapp.com/api"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


init : () -> ( Model, Cmd Msg )
init _ =
    ( NotAsked, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ClickedLoadData n ->
            ( Loading, fetchData n )

        GotResponse newModel ->
            ( newModel, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        NotAsked ->
            div []
                [ text "Nothing has been requested..."
                , br [] []
                , br [] []
                , button [ onClick (ClickedLoadData "1001") ] [ text "Load data! (1001)" ]
                , button [ onClick (ClickedLoadData "1004") ] [ text "Load data! (1004)" ]
                , button [ onClick (ClickedLoadData "999") ] [ text "Load data! (999)" ]
                ]

        Loading ->
            text "Loading..."

        Failure _ ->
            text "Oh noes, the request failed!"

        Success Nothing ->
            text "No human found!"

        Success (Just humanData) ->
            text <| "Got data: " ++ humanData.name


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
