module Button exposing (..)

import Browser
import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (style, placeholder, type_)


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = { number: Int, threshold: String }

init : Model
init =
  { number = 0, threshold = "" }


-- UPDATE

type Msg = Increment | Decrement | Reset | UpdateName String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      { model | number = model.number + 1 }

    Decrement ->
      { model | number = model.number - 1 }

    Reset ->
      { model | number = 0 }

    UpdateName threshold ->
      { model | threshold = threshold }

higherThan5 : Int -> String -> Html Msg
higherThan5 n threshold =
  if n > 5 then
    div [ style "color" "red" ] [ text "higher than 5" ]
  else
    div [] []

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model.number) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset" ]
    , higherThan5 model.number
    , input [ type_ "number", onInput UpdateName, placeholder "number in which shows the error" ] [ ]
    ]