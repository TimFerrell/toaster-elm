import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)

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

-- TODO: need to grow the model out to support something like the following:
-- AddToast Toast
-- RemoveToast Toast.id
-- (Assuming that we always immediately show toasts that we receive)
type alias Model = List Toast

fakeToast : Toast
fakeToast = {kind = "nah", title = "greets", message = "hi there"}

emptyModel : Model
emptyModel = []

update : Toast -> Model -> Model
update toast model = toast :: model

init : Maybe Model -> Model
init oldModel =
  Maybe.withDefault emptyModel oldModel

renderToast : Toast -> Html Toast
renderToast toast =
  div
    [] -- no styles for now!
    [ span
        []
        [text toast.message]
    ]

view : Model -> Html Toast
view model =
  div
    []
    (header :: (List.map renderToast model))

header : Html Toast
header =
  div
    []
    [button [onClick fakeToast] [text "Add Toast"]]
