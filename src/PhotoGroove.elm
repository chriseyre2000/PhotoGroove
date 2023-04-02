module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (button, div, h1, h3, img, input, label, text, Html)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


urlPrefix : String
urlPrefix = 
  "http://elm-in-action.com/"

type alias Photo = 
  { url : String }  

type ThumbnailSize 
  = Small
  | Medium
  | Large

type alias Model = 
  { photos: List Photo
  , selectedUrl: String
  , chosenSize : ThumbnailSize
  }

type alias Msg =
  {description : String, data : String }  

view : Model -> Html Msg
view model =
  div [ class "content" ]
     [ h1 [] [ text "Photo Groove" ]
       , button 
         [onClick {description = "ClickSurpriseMe", data = "" }]
         [text "Surprise Me!"]
       , h3 [] [ text "Thumbnail Size:" ]
       , div [ id "chosese-size"]
         (List.map viewSizeChooser [Small, Medium, Large])
       , div [ id "thumbnails", class (sizeToString model.chosenSize) ]
        (List.map (viewThumbnail model.selectedUrl) model.photos)
       , img 
           [class "large"
         , src (urlPrefix ++ "large/" ++ model.selectedUrl)
        ] 
         []
     ] 

viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumb =
  img
    [src (urlPrefix ++ thumb.url)
    , classList [("selected", selectedUrl == thumb.url) ] 
    , onClick { description = "ClickedPhoto", data = thumb.url }
    ] 
    []

viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
  label []
    [
      input [ type_ "radio", name "size" ] []
    , text (sizeToString size)
    ]

sizeToString : ThumbnailSize -> String
sizeToString size =
  case size of
    Small ->
      "small"
    Medium ->
      "medium"
    Large ->
      "large"

initialModel: Model
initialModel =
  { photos = 
  [  { url = "1.jpeg"}
   , { url = "2.jpeg"}
   , { url = "3.jpeg"}
  ]
  , selectedUrl = "1.jpeg"  
  , chosenSize = Medium   
  }

photoArray : Array Photo
photoArray = 
  Array.fromList initialModel.photos

getPhotoUrl : Int -> String
getPhotoUrl index =
  case Array.get index photoArray of
    Just photo ->
      photo.url
    Nothing ->
      "" 

update : Msg -> Model -> Model
update msg model = 
  case msg.description of
  "ClickedPhoto" ->
    { model | selectedUrl = msg.data}
  "ClickSurpriseMe" ->
    { model | selectedUrl = "2.jpeg"}  
  _ ->
    model  


main = 
  Browser.sandbox
  { init = initialModel
   , view = view
   , update = update
  }
