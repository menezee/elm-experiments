module Checkbox exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type Model = Selected | NotSelected

init : Model
init =
  NotSelected


-- UPDATE

type Msg = Select | Deselect

update : Msg -> Model -> Model
update msg model =
  case msg of
    Select ->
      Selected

    Deselect ->
      NotSelected


-- VIEW

handleSelected : Bool -> Msg
handleSelected isSelected =
    if isSelected then Select else Deselect

view : Model -> Html Msg
view model =
  div []
    [ label []
        [ text "Select ->"
        , input [ type_ "checkbox", onCheck handleSelected ] []
        ]
    , (\() -> if model == Selected then div [ class "warning" ] [ text "selected" ] else div [ class "warning" ] [ text "not selected" ])()
    , h1 [] [ text "HEY NOW" ]
    ]

