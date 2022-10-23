module Main exposing (..)

import Browser
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))
import StarWars.Enum.Episode exposing (Episode(..))
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
    , avatarUrl : String
    , appearsIn : List StarWars.Enum.Episode.Episode
    }


query : String -> SelectionSet (Maybe HumanData) RootQuery
query n =
    Query.human { id = Id n }
        humanSelection


humanSelection : SelectionSet HumanData StarWars.Object.Human
humanSelection =
    SelectionSet.map4 HumanData
        Human.name
        Human.homePlanet
        Human.avatarUrl
        Human.appearsIn


type Msg
    = ClickedLoadData String
    | GotResponse Model


type alias Response =
    Maybe HumanData


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


viewButtons : List (Html Msg)
viewButtons =
    [ button [ onClick (ClickedLoadData "1001") ] [ text "Load data! (1001)" ]
    , button [ onClick (ClickedLoadData "1004") ] [ text "Load data! (1004)" ]
    , button [ onClick (ClickedLoadData "999") ] [ text "Load data! (999)" ]
    ]


view : Model -> Html Msg
view model =
    case model of
        NotAsked ->
            div []
                [ text "Nothing has been requested..."
                , div [ style "margin-top" "20px" ] viewButtons
                ]

        Loading ->
            text "Loading..."

        Failure _ ->
            div []
                [ p [] [ text "Oh noes, the request failed!" ]
                , div [ style "margin-top" "20px" ] viewButtons
                ]

        Success Nothing ->
            div []
                [ p [] [ text <| "No human found with this id!" ]
                , div [ style "margin-top" "20px" ] viewButtons
                ]

        Success (Just human) ->
            div []
                [ h1 [] [ text human.name ]
                , p []
                    [ case human.homePlanet of
                        Nothing ->
                            text "From unknown origins"

                        Just homePlanet ->
                            text ("His home planet is: " ++ homePlanet)
                    ]
                , div []
                    [ case human.appearsIn of
                        [] ->
                            p [] [ text "No appearences :(" ]

                        _ ->
                            let
                                toLi : Episode -> Html msg
                                toLi episode =
                                    li [] [ text (episodeToStr episode) ]
                            in
                            div []
                                [ h3 [] [ text "List of appearences..." ]
                                , ul [] (List.map toLi human.appearsIn)
                                ]
                    ]
                , div [ style "margin-top" "20px" ] viewButtons
                ]


episodeToStr : Episode -> String
episodeToStr episode =
    case episode of
        Newhope ->
            "A New Hope (1977)"

        Empire ->
            "The Empire Strikes Back (1980)"

        Jedi ->
            "The Return Of The Jedi (1983)"


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
