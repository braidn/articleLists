module Article exposing (view, Model)

import Html exposing (Html, strong, span, em, a, text)
import Html.Attributes exposing (class, href)

-- defines the contract of the article model
type alias Model =
  { title : String, url : String, postedBy : String, postedOn : String  }

-- when calling Article.view we will pass in an article as a single parameter
view : Model -> Html a
view model =
  span [ class "article" ]
    [ a [ href model.url ] [ strong [  ] [ text model.title ] ] 
    , span [  ] [ text (" Posted by: " ++ model.postedBy ) ]
    , em [  ] [ text (" (posted on: " ++ model.postedOn ++ ")") ]
    ]
