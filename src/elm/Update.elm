module Update exposing (..)

{-| Just do nothing -}
none : model -> ( model, Cmd msg )
none model = ( model, Cmd.none )

{-| Bundles one command with the Model -}
withCmd : Cmd msg -> model -> ( model, Cmd msg )
withCmd cmd model = ( model, cmd )

{-| Bundles some commands with the Model -}
withCmds : List (Cmd msg) -> model -> ( model, Cmd msg )
withCmds cmds model = ( model, Cmd.batch cmds )
