module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model =
  { list : List Int, selected : Int }

init : Model
init =
    { list = [1, 2, 3], selected = 1 }


-- UPDATE

type Msg = Select Int

update : Msg -> Model -> Model
update msg model =
    case msg of
        Select i ->
          { model | selected = i }


-- VIEW

renderChild n =
    div [ style "border" "1px solid black", onClick ((\i -> Select i) n) ] [ text (String.fromInt n) ]

view : Model -> Html Msg
view model =
    div []
    [ div [ style "display" "flex" ] (List.map renderChild model.list)
    , text ("Selected: " ++ String.fromInt model.selected)
    ]
