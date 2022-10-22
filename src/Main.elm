module Main exposing (..)

import Browser
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Html exposing (..)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))
import StarWars.Interface exposing (Character)
import StarWars.Interface.Character
import StarWars.Query as Query



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


query : SelectionSet String RootQuery
query =
    Query.hello


type Msg
    = ClickedLoadData
    | GotResponse Model


type alias Response =
    String



-- Character


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


fetchData : Cmd Msg
fetchData =
    query
        |> Graphql.Http.queryRequest "https://elm-graphql.herokuapp.com/api"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


init : () -> ( Model, Cmd Msg )
init _ =
    ( NotAsked, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ClickedLoadData ->
            ( Loading, fetchData )

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
                , button [ onClick ClickedLoadData ] [ text "Load data!" ]
                ]

        Loading ->
            text "Loading..."

        Failure _ ->
            text "Oh noes, the request failed!"

        Success data ->
            text <| "Got data: " ++ data


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
