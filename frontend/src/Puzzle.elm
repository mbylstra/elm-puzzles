module Puzzle exposing (..)


type alias Puzzle =
    { name : String
    , description : String
    , functionCallExpression : String
    , workingSolution : String
    }


puzzles : List Puzzle
puzzles =
    [ { name = "Reverse a string using the core libraries"
      , description = ""
      , functionCallExpression = "reverse \"Hello World!\""
      , workingSolution = "reverse = String.reverse"
      }
    , { name = "Reverse a string using foldr"
      , description = ""
      , functionCallExpression = "reverse \"Hello World!\""
      , workingSolution = "reverse = String.foldr String.cons \"\""
      }
    ]
