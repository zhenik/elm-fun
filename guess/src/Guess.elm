module Guess exposing (Model, Msg(..), checkResult, genResult, initModel, main, revealAndIncrement, update, view)

import Browser exposing (..)
import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = initModel, update = update, view = view }


type alias Model =
    { word : String
    , guess : String
    , revealedWord : { pos : Int, text : String }
    , result : String
    }


initModel : Model
initModel =
    Model "Saturday" "" { pos = 2, text = "" } ""


type Msg
    = Answer String
    | Reveal
    | Check


update : Msg -> Model -> Model
update msg model =
    case msg of
        Answer txt ->
            { model | guess = txt }

        Reveal ->
            { model | revealedWord = revealAndIncrement model }

        Check ->
            { model | result = checkResult model }


checkResult : Model -> String
checkResult { word, guess } =
    if word == guess then
        "You got it"

    else
        "No"


revealAndIncrement : Model -> { pos : Int, text : String }
revealAndIncrement { revealedWord, word } =
    if revealedWord.text == word then
        revealedWord

    else
        { revealedWord | pos = revealedWord.pos + 1, text = String.slice 0 revealedWord.pos word }


genResult : Model -> Html Msg
genResult { result } =
    if String.length result < 1 then
        div [] []

    else if result == "No" then
        div [ style "fontColor" "red" ] [ text result ]

    else
        div [ style "color" "green" ] [ text result ]


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text ("I am thinking of a word that starts with " ++ model.revealedWord.text) ]
        , input [ placeholder "Type your guesss", onInput Answer ] []
        , button [ onClick Reveal ] [ text "Give me a hint" ]
        , button [ onClick Check ] [ text "Submit answer" ]
        , div [] [ text model.result ]

        -- , div [] [ text (toString model) ]
        ]
