module ToastTypes exposing (..)

type alias Id = Int

type alias Toast =
  { kind : String
  , title : String
  , message : String
  , id : Id
  }
