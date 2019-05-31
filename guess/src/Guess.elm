module Guess exposing (..)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import Debug exposing (..)


main = 
    Browser.sandbox {init = initModel, update = update, view = view }

type alias Model =
    { word: String , guess: String, isCorrect: Bool }
initModel : Model
initModel = 
    Model "Saturday" "" False

type Msg =
    Answer String

update : Msg -> Model -> Model
update msg model = 
    case msg of
        Answer txt -> 
            { model | guess = txt, isCorrect = checkIfCorrect model txt }

checkIfCorrect : Model -> String -> Bool
checkIfCorrect model txt = 
    if txt == model.word then
        True 
    else 
        False

generateResult : Model -> Html Msg
generateResult { isCorrect } = 
    if isCorrect then
        text "You got it"
    else 
        text "No"

view : Model -> Html Msg
view model = 
    div [] [
        h2 [] [text ("I am thinking of a word that starts with " ++ toString (String.slice 0 1 model.word))]
        , input [placeholder "Type your guesss", onInput Answer] []
        , div [] [generateResult model]
    ]