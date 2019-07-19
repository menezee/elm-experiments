module Main exposing (Issue, Issues, Model(..), Msg(..), getIssues, init, issueDecoder, issueItem, issueListDecoder, issueListView, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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


type alias Issue =
    { title : String, html_url : String, avatar_url : String }


type alias Issues =
    List Issue


type Model
    = Ready Issues
    | Loading
    | Error


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getIssues )



-- UPDATE


type Msg
    = FetchIssues
    | NewIssues (Result Http.Error (List Issue))



--update : Msg -> (Result, Cmd Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchIssues ->
            ( Loading, getIssues )

        NewIssues result ->
            case result of
                Ok issues ->
                    ( Ready issues, Cmd.none )

                Err _ ->
                    ( Error, Cmd.none )



-- HTTP


getIssues : Cmd Msg
getIssues =
    Http.get
        { url = "https://api.github.com/repos/vmg/redcarpet/issues"
        , expect = Http.expectJson NewIssues issueListDecoder
        }


issueDecoder : D.Decoder Issue
issueDecoder =
    D.map3 Issue (D.field "title" D.string) (D.field "html_url" D.string) (D.field "user" (D.field "avatar_url" D.string))


issueListDecoder : D.Decoder (List Issue)
issueListDecoder =
    D.list issueDecoder



-- VIEW


view : Model -> Html Msg
view model =
    div []
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
    li [ style "line-height" "40px" ]
        [ a [ href issue.html_url, target "_blank" ] [ text issue.title ]
        , img [ style "width" "35px", style "padding-left" "10px", src issue.avatar_url ] []
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
