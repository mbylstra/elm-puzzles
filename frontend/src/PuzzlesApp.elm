port module PuzzlesApp exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Http exposing (Request)
import Json.Encode


-------------------------------------------------------------------------------
-- PROGRAM
-------------------------------------------------------------------------------


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }



-------------------------------------------------------------------------------
-- MODEL
-------------------------------------------------------------------------------


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, compilationCmd helloWorld )



-------------------------------------------------------------------------------
-- UPDATE
-------------------------------------------------------------------------------


helloWorld : String
helloWorld =
    """module Main exposing (main)

import Html exposing (Html)

main : Html msg
main =
    Html.text "Hello, World!"
"""


type Msg
    = CompilationResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompilationResponse result ->
            case (Debug.log "r" result) of
                Ok javascriptSource ->
                    ( model, newlyCompiledElmSource javascriptSource )

                Err err ->
                    Debug.crash <| toString err



-------------------------------------------------------------------------------
-- VIEW
-------------------------------------------------------------------------------


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Elm Puzzles" ]
        , div [] []
        ]



-------------------------------------------------------------------------------
-- REQUESTS
-------------------------------------------------------------------------------


compilationServiceUrl : String
compilationServiceUrl =
    "http://localhost:8080/compile"


compilationRequest : String -> Request String
compilationRequest source =
    let
        encodeCompilationBody : String -> Json.Encode.Value
        encodeCompilationBody source =
            Json.Encode.object
                [ ( "source", Json.Encode.string source )
                , ( "runtime", Json.Encode.bool True )
                ]
    in
        Http.request
            { method = "POST"
            , headers = []
            , url = compilationServiceUrl
            , body = Http.jsonBody (encodeCompilationBody source)
            , expect = Http.expectString
            , timeout = Nothing
            , withCredentials = False
            }


compilationCmd : String -> Cmd Msg
compilationCmd source =
    compilationRequest source
        |> Http.send CompilationResponse



-------------------------------------------------------------------------------
-- PORTS
-------------------------------------------------------------------------------


port newlyCompiledElmSource : String -> Cmd msg
