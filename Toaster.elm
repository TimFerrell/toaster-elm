import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)

import List exposing (..)

import ToastTypes exposing (..)

main : Program Never
main =
  App.beginnerProgram
     { model = emptyModel
     , view = view
     , update = update
     }
  -- App.programWithFlags
  --    { init = init
  --    , view = view
  --    , update = update
  --    , subscriptions = \_ -> Sub.none
  --    }

type alias Model = List Toast

type Action
  = NoOp -- these guys are useful with timers
  | Add Toast
  | Remove Id
  | Pop

fakeToast : Action
fakeToast = Add {kind = "nah", title = "greets", message = "hi there", id = -1}

popToast : Action
popToast = Pop

emptyModel : Model
emptyModel = []

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model

    Add toast ->
      {toast | id = length model } :: model

    Remove id ->
      filter (\toast -> toast.id /= id) model

    Pop ->
      take ((List.length model) - 1) model

init : Maybe Model -> Model
init oldModel =
  Maybe.withDefault emptyModel oldModel

renderToast : Toast -> Html Action
renderToast toast =
  div
    [] -- no styles for now!
    [ span
        []
        [text toast.message]
    ]

view : Model -> Html Action
view model =
  div
    []
    (header :: (map renderToast model))

makeButton : Action -> String -> Html Action
makeButton action btn_text =
  button
    [onClick action]
    [text btn_text]

header : Html Action
header =
  div
    []
    [ (makeButton fakeToast "Add Toast")
    , (makeButton popToast "Remove Toast")
    ]
