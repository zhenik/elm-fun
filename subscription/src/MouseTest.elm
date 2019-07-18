module MouseTest exposing (..)
import Browser
import Html exposing (..)
import Html.Events.Extra.Mouse as Mouse


main : Program () MouseEvent MouseEvent
main =
    Browser.sandbox
        { init = None
        , view = view
        , update = always
        }


type MouseEvent
    = None
    | Down Mouse.Event
    | Move Mouse.Event
    | Up Mouse.Event
    | Click Mouse.Event
    | DoubleClick Mouse.Event
    | Over Mouse.Event
    | Out Mouse.Event
    | ContextMenu Mouse.Event


view : MouseEvent -> Html MouseEvent
view event =
    div []
        [ p
            [ Mouse.onDown Down
            , Mouse.onMove Move
            , Mouse.onUp Up
            , Mouse.onClick Click
            , Mouse.onDoubleClick DoubleClick
            , Mouse.onOver Over
            , Mouse.onOut Out
            , Mouse.onContextMenu ContextMenu
            ]
            [ text <| Debug.toString event ]
        ]