import Browser
import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

main = 
 Browser.sandbox { init = init, update = update, view = view }

-- Model 
type alias Model = { leftString : String, rightString : String }
type Msg = Left String
         | Right String

init : Model
init = { leftString = "", rightString = "" }

-- View
view : Model -> Html Msg
view model = 
  div []
    [ input [ placeholder "String 1", value model.leftString, onInput Left ] []
    , input [ placeholder "String 2", value model.rightString, onInput Right ] []
    , div [] [ text (model.leftString), text " : ", text (model.rightString) ]

    ]

-- Update
update : Msg -> Model -> Model
update msg model = 
  case msg of 
      Left newContent->
        { model | leftString = newContent }

      Right newContent ->
        { model | rightString = newContent }