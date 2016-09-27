-- acts like a module exports in es6
module Components.ArticleList exposing (..)

-- act like imports to import items from elm packages
import Html exposing (Html, text, ul, li, div, h2, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Task
import Json.Decode as Json exposing ((:=))
import Debug
import List
import Article

type alias Model = 
  { articles : List Article.Model }

type SubPage
  = ListView
  | ShowView Article.Model

-- Msg union type
type Msg
  = NoOp
  | Fetch
  | FetchSucceed (List Article.Model)
  | FetchFail Http.Error
  | RouteToNewPage SubPage

-- update fn. defines every possibility from the union 
-- type and to do if a msg is invoked
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    NoOp ->
      (model, Cmd.none)
    Fetch ->
      (model, fetchArticles)
    FetchSucceed articleList ->
      (Model articleList, Cmd.none)
    FetchFail error ->
      case error of
        Http.UnexpectedPayload errorMessage ->
          Debug.log errorMessage
          (model, Cmd.none)
        _ ->
          (model, Cmd.none)
    _ ->
      (model, Cmd.none)


-- dummy data / dot notation to drive inside the object.
articles : Model
articles = 
  { articles = 
    [ { title = "Article 1", url = "http://www.google.com",
        postedBy = "Author 1", postedOn = "07/22/16" } 
      , { title = "Article 5", url = "http://www.google.com",
        postedBy = "Author 2", postedOn = "07/22/16" } 
      , { title = "Article 3", url = "http://www.google.com",
        postedBy = "Author 3", postedOn = "07/22/16" } ] }


fetchArticles : Cmd Msg
fetchArticles =
  let
    url = "api/articles"
  in
    -- First arg is fail, second arg is success, and third arg is what it actually is doing.
    Task.perform FetchFail FetchSucceed (Http.get decodeArticleFetchUrl)

-- Get the data at the node 'data'
decodeArticleFetch : Json.Decoder (List Article.Model)
decodeArticleFetch = 
  Json.at ["data"] decodeArticleList

-- Pass the information in the data node to a list of Elm JSON decoders.
decodeArticleList : Json.Decoder (List Article.Model)
decodeArticleList = 
  Json.list decodeArticleData

decodeArticleData : Json.Decoder Article.Model
decodeArticleData =
  -- Actually pulling four keys out of the structure of the JSON object
  -- I would hope that this method implementation did some trickery on the int for dryness sake
  Json.object4 Article.Model
    ("title":=Json.string)
    ("url":=Json.string)
    ("posted_by":=Json.string)
    ("posted_on":=Json.string)

articleLink : Article.Model -> Html Msg
articleLink =
  a
  [ href("article/" ++ article.title ++ "/show") 
  , oncClick (RouteToNewPage (ShowView article)) ]
  [ text " Show" ]

-- setup the rudimentary single view item
renderArticle : Article.Model -> Html Msg
renderArticle article = 
  li [] [
    div [] [ Article.view article, articleLink article ]
  ]

-- take single view item and map it over each article 
renderArticles : Model -> List (Html a)
renderArticles articles =
  List.map renderArticle articles.articles

-- simply signifies the initial state of the data
initialModel : Model
initialModel = 
  { articles = [] }

view : Model -> Html Msg
view model = 
  div [ class "article-list" ] 
    [ h2 [] [ text "Article List" ]
    , button [ onClick Fetch, class "btn btn-primary" ] [ text "Fetch Articles" ]
    , ul [] (renderArticles model) ]
