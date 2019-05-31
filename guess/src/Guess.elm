module Guess exposing (..)

import Browser exposing (..)
import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = initModel, update = update, view = view }


type alias Model =
    { 
        word : String, 
        guess : String, 
        isCorrect : Bool, 
        revealedWord: { pos: Int, text: String }
    }


initModel : Model
initModel =
    Model "Saturday" "" False {pos= 2, text=""}


type Msg
    = Answer String
    | Reveal


update : Msg -> Model -> Model
update msg model =
    case msg of
        Answer txt ->
            { model | guess = txt, isCorrect = checkIfCorrect model txt }

        Reveal ->
            { model | revealedWord = revealAndIncrement model }

revealAndIncrement : Model -> {pos: Int, text: String}
revealAndIncrement { revealedWord, word } =
    if revealedWord.text == word then
        revealedWord 
    else
        { revealedWord | pos = revealedWord.pos + 1, text = String.slice 0 revealedWord.pos word}


-- revealLetter : Model -> String
-- revealLetter model =
--     if String.length model.word == String.length model.revealedWord then
--         model.word

--     else
--         String.slice 0 model.revealedPos model.word


checkIfCorrect : Model -> String -> Bool
checkIfCorrect model txt =
    if txt == model.word then
        True

    else
        False


generateResult : Model -> Html Msg
generateResult { isCorrect, revealedWord, word } =
    let 
        txt =
            if revealedWord.text == word then
                "You did not guess it"
            else if isCorrect then
                "You got it"
            else
                "No"
    in 
        text txt

view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text ("I am thinking of a word that starts with " ++ model.revealedWord.text) ]
        , input [ placeholder "Type your guesss", onInput Answer ] []
        , button [ onClick Reveal ] [ text "Give me a hint" ]
        , div [] [ generateResult model ]

        -- , div [] [ text (toString model) ]
        ]
