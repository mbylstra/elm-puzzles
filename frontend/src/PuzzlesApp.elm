port module PuzzlesApp exposing (..)

import Html exposing (Html, text, div, h1, img, textarea, button, p)
import Html.Attributes exposing (src, class, defaultValue)
import Http exposing (Request)
import Json.Encode
import Html.Events exposing (onInput, onClick)


-------------------------------------------------------------------------------
-- PROGRAM
-------------------------------------------------------------------------------


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always (renderedAnswerReady RenderedAnswerReady)
        }



-------------------------------------------------------------------------------
-- CONSTANTS
-------------------------------------------------------------------------------


compilationServiceUrl : String
compilationServiceUrl =
    "http://localhost:8080/compile"


helloWorld : String
helloWorld =
    """module Main exposing (main)

import Html exposing (Html)

main : Html msg
main =
    Html.text "Hello, World!"
"""



-------------------------------------------------------------------------------
-- MODEL
-------------------------------------------------------------------------------


type alias Model =
    { source : String
    , currentPuzzleIndex : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { source = ""
      , currentPuzzleIndex = 0
      }
    , Cmd.none
    )



-------------------------------------------------------------------------------
-- UPDATE
-------------------------------------------------------------------------------


type Msg
    = CompilationResponse (Result Http.Error String)
    | SourceUpdated String
    | SubmitSourceCode
    | RenderedAnswerReady String
    | NextPuzzle


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "msg" msg) of
        CompilationResponse result ->
            case (Debug.log "r" result) of
                Ok javascriptSource ->
                    ( model, newlyCompiledElmSource javascriptSource )

                Err err ->
                    Debug.crash <| toString err

        SourceUpdated source ->
            ( { model | source = source }, Cmd.none )

        SubmitSourceCode ->
            ( model, compileStringTransformationFunction model.source )

        RenderedAnswerReady text ->
            ( model, Cmd.none )

        NextPuzzle ->
            ( { model | currentPuzzleIndex = model.currentPuzzleIndex + 1 }
            , Cmd.none
            )



-------------------------------------------------------------------------------
-- VIEW
-------------------------------------------------------------------------------


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Elm Puzzles" ]
        , p [] [ text "Write a function named reverse that reverses a string" ]
        , textarea [ class "editor", onInput SourceUpdated, defaultValue model.source ] []
        , button [ onClick SubmitSourceCode ] [ text "Compile" ]
        , text " "
        , button [ onClick NextPuzzle ] [ text "Next Puzzle" ]
        , div [] []
        ]



-------------------------------------------------------------------------------
-- REQUESTS
-------------------------------------------------------------------------------


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


compileStringTransformationFunction : String -> Cmd Msg
compileStringTransformationFunction functionSource =
    let
        fullSource =
            """module Main exposing (main)

import Html exposing (Html)

main : Html msg
main =
    Html.text (reverse "Hello, World!")

"""
                ++ functionSource
    in
        compilationCmd (Debug.log "fullSource" fullSource)



-------------------------------------------------------------------------------
-- PORTS
-------------------------------------------------------------------------------


port newlyCompiledElmSource : String -> Cmd msg


port renderedAnswerReady : (String -> msg) -> Sub msg
