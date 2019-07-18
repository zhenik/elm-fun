module TimerSubscriptions exposing (..)

import Debug exposing (..)
import Html.Events.Extra.Mouse as Mouse
import Browser
import Html exposing (..)
import Task
import Time

type alias Model =
  { text : String
  , mouseXPos : Float
  , mouseYPos : Float
  }

init : () -> (Model, Cmd Msg)
init _ = ( Model "test text" 0 0 , Cmd.none)

type Msg = 
  MouseClicked Mouse.Event

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MouseClicked event ->
      ( { model 
          | text = Debug.toString event
          , mouseXPos = Tuple.first event.pagePos
          , mouseYPos = Tuple.second event.pagePos
        }
      , Cmd.none
      )
      
view : Model -> Html Msg
view model =
      div [Mouse.onDown MouseClicked] [ text (toString model) ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


    -- MAIN
main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }