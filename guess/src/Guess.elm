module Guess exposing (Model, Msg(..), checkResult, genResult, initModel, main, revealAndIncrement, update, view)

import Browser exposing (..)
import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = initModel, update = update, view = view }


type alias RevealedWord =
    { pos : Int, text : String }


type alias Result =
    { text : String, isCorrect : Bool }


type alias Model =
    { word : String
    , guess : String
    , revealedWord : RevealedWord
    , result : Result
    , wordList : List String
    }


initWordList : List String
initWordList =
    [ "Monday", "Tuesday", "Wednesday", "Saturday", "Friday" ]


initModel : Model
initModel =
    Model "Saturday" "" { pos = 2, text = "" } { text = "", isCorrect = False } initWordList


type Msg
    = Answer String
    | Reveal
    | Check
    | Another


update : Msg -> Model -> Model
update msg model =
    case msg of
        Answer txt ->
            { model | guess = txt }

        Reveal ->
            { model | revealedWord = revealAndIncrement model }

        Check ->
            { model | result = checkResult model }

        Another ->
            let
                newWord =
                    getNewWord model
            in
            { model
                | word = newWord
                , guess = ""
                , revealedWord = { pos = 2, text = String.slice 0 1 newWord }
                , wordList = List.drop 1 model.wordList
            }


getNewWord : Model -> String
getNewWord { wordList, word } =
    wordList
        |> List.filter (\w -> w /= word)
        |> List.take 1
        |> String.concat


checkResult : Model -> Result
checkResult { word, guess, result } =
    if String.toLower word == String.toLower guess then
        { result | text = "You got it", isCorrect = True }

    else
        { result | text = "No", isCorrect = False }


revealAndIncrement : Model -> RevealedWord
revealAndIncrement { revealedWord, word } =
    if revealedWord.text == word then
        revealedWord

    else
        { revealedWord | pos = revealedWord.pos + 1, text = String.slice 0 revealedWord.pos word }


genResult : Model -> Html Msg
genResult { result } =
    if String.isEmpty result.text then
        div [] []

    else
        let
            color =
                if result.isCorrect then
                    "green"

                else
                    "red"
        in
        div [ style "color" color ] [ text result.text ]


view : Model -> Html Msg
view model =
    div
        [ style "textAlign" "center"
        , style "fontSize" "2em"
        , style "fontFamily" "monospace"
        ]
        [ h2 [] [ text ("I am thinking of a word that starts with " ++ model.revealedWord.text) ]
        , input [ placeholder "Type your guesss", onInput Answer ] []
        , p []
            [ button [ onClick Reveal ] [ text "Give me a hint" ]
            , button [ onClick Check ] [ text "Submit answer" ]
            , button [ onClick Another ] [ text "Another word" ]
            ]
        , div []
            [ text model.result.text
            ]

        -- , div [] [ text (toString model) ]
        ]
