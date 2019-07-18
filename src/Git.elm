import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as D


-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

--type alias Issues = List Issue
--
--type alias Issue =
--    { url : String
--    , id : Int
--    , title : String
--    , body : String
--    }

type alias Issue =
  { title : String }

type alias Issues = List Issue

type Model
  = Ready Issues
  | Loading
  | Error

init : () -> (Model, Cmd Msg)
init _ =
  (Loading, getIssues)

-- UPDATE


type Msg
  = FetchIssues
  | NewIssues (Result Http.Error (List Issue))


--update : Msg -> (Result, Cmd Msg)
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      FetchIssues ->
          (Loading, getIssues)

      NewIssues result ->
        case result of
            Ok issues ->
              (Ready issues, Cmd.none)

            Err _ ->
              (Error, Cmd.none)


-- HTTP


getIssues : Cmd Msg
getIssues =
  Http.get
    { url = "https://api.github.com/repos/vmg/redcarpet/issues"
    , expect = Http.expectJson NewIssues issueListDecoder
    }


issueDecoder : D.Decoder Issue
issueDecoder =
  D.map Issue (D.field "title" D.string)

issueListDecoder : D.Decoder (List Issue)
issueListDecoder =
 D.list issueDecoder


-- VIEW


view : Model -> Html Msg
view model =
    div[]
      [ h1 [] [ text "Welcome to Git Issues" ]
      , button [ onClick FetchIssues ] [ text "Fetch Issues" ]
      , issueListView model
      ]

issueListView : Model -> Html Msg
issueListView model =
  case model of
    Loading ->
      div []
        [ h4 [] [ text "Loading issues" ] ]

    Error ->
      div []
        [ h4 [] [ text "Error loading issues" ] ]

    Ready issues ->
      div []
        [ h4 [] [ text "Issues list" ]
        , ul [] (List.map issueItem issues)
        ]

issueItem : Issue -> Html Msg
issueItem issue =
  li [] [ text issue.title ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none