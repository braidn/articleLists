module Main exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Components.ArticleList as ArticleList
import Components.ArticleShow as ArticleShow

-- MODEL

type alias Model =
  { articleListModel : ArticleList.Model
  , currentView : Page }

type Page
  = PageView
  | ArticleListView
  | ArticleShowView Artivle.Model

initialModel : Model
initialModel = 
  { articleListModel = ArticleList.initialModel }

-- initializer fn, runs when the main.elm is booted?
init : (Model, Cmd Msg)
init =
  ( initialModel, Cmd.none )

-- UPDATE

type Msg
  = ArticleListMsg ArticleList.Msg
  | UpdateView Page
  | ArticleShowMsg ArticleShow.Msg

-- likely the place where I know the least about what's going on overall.
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ArticleListMsg articleMsg ->
      let
          (updateModel, cmd) = ArticleList.update articleMsg model.articleListModel
      in
         ( { model | articleListModel = updateModel }, Cmd.map ArticleListMsg cmd )
    UpdateView page ->
      case page of
        ArticleListView ->
          ({ model | currentView = page }, Cmd.map ArticleListMsg ArticleList.fetchArticles)
        _ ->
          ({ model | currentView = page }, Cmd.none)
      
-- for now we don't actually have anything to sub to so noop
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

articleListview : Model -> Html Msg
articleListModel mode = 
  Html.App.map ArticleListMsg ( ArticleList.view model.articleListModel )

welcomeView : Html Msg
welcomeView =
  h2 [] [ text "Welcome to Elm Articles!" ]

pageView : Model -> Html Msg
pageView model = 
  case model.currentView of
    RootView ->
      welcomeView
    ArticleListView ->
      articleListView Model
      

view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
    [ header, pageView model ]

header : Html Msg
header =
  div []
  [ h1 [] [ text "Elm Articles" ]
  , ul []
  [ li [] [ a [ href "#", onClick (UpdateView RootView) ] [ text "Home" ] ]
  , li [] [ a [ href "#articles", onClick (UpdateView ArticleListView) ] [ text "Articles" ] ]
  ]
  ]

-- MAIN

-- like most main func, this bootstraps the app and maps funcs to the pertinent imputs.
main : Program Never
main =
  Html.App.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions }
