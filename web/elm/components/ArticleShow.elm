module Components.ArticleView exposing (..)

import Components.Article as Article
import Html exposing (..)
import Html.Attributes exposing (href)

type Msg = NoOp

view : Article.Model -> Html Msg
view model =
  div [] 
  [ h3 [] [ text model.title ] 
  , a [ href model.url ] [ text ("URL: " ++ model.url) ]
  , br [] []
  , span [] [ text ("Posted by: " ++ model.postedBy ++ " On: " ++ model.postedOn) ] ]
