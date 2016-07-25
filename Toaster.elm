import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)

import List exposing (..)

import Task -- need to ask the outside world what the time is
            -- there's probably a slick way to put the timeout
            -- in a CSS fade, but I don't know CSS!
            -- and of course we'd have to generate a signal
            -- to tell Elm to update it's model, so hmmm.

import Time exposing (Time, second)

import ToastTypes exposing (..)

defaultTimeout : Time
defaultTimeout = 3 * second

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
  = Tick
  | Add Toast
  | Remove Id
  | Pop

fakeToast : Action
fakeToast = Add {kind = "nah", title = "greets", message = "hi there", id = -1, started = (0 * second)}

popToast : Action
popToast = Pop

emptyModel : Model
emptyModel = []

update : Action -> Model -> Model
update action model =
  case action of
    Tick -> model
            -- So, I'd kind of like to age things out based purely on ticks,
            -- but to guarantee consistent lifetimes I'd have to cache Adds/Removes
            -- and do them in this handler. Which isn't so cool.
            --
            -- I assume the JS Toastr just uses setTimeout or something?
            -- Which we can do with Tasks and such, but it's not very elegant.
            --
            -- Another thought: assuming a CSS fadeout, maybe it's not a big
            -- deal if the DOM and our Elm model are occasionally inconsistent?
            -- Then I'd just have to ensure the number of ticks a toast
            -- gets is greater (but not too much!) than the CSS fadeout

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
