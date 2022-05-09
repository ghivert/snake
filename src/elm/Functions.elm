module Functions exposing (..)

flip : (a -> b -> c) -> b -> a -> c
flip fun a b = fun b a
