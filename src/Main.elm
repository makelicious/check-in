module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Element exposing (Element, el, text, row, column, alignRight, fill, width, rgb255, spacing, centerY, padding, centerX, centerY, alignTop, height, px, paddingEach)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Border as Border
import Maybe exposing (Maybe)

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

---- MODEL ----

type alias Question =
    {
        title : String
    ,   choices : List String
    }


type alias Model = Question


init : ( Model, Cmd Msg )
init =
    ( {title = "Name", choices = ["yy", "kaa", "koo"]}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.layout [
        Background.color (rgb255 233 233 233)
    ]
    (wrapper model)

wrapper : Model -> Element msg
wrapper model =
    column
        [ centerX
        , centerY
        ]
        [(viewTitle (model.title)), (box (model.choices)), questionBox]

questionBox : Element msg
questionBox =
    row
        [ alignTop
        , paddingEach
            { top = 0
            , right = 0
            , bottom = 30
            , left = 0
            }
        ][]

viewTitle : String -> Element msg
viewTitle title =
    el
        [ width fill
        , alignTop
        , paddingEach
            { top = 0
            , right = 0
            , bottom = 30
            , left = 0
            }
        ]
        (text (title))

box : List String -> Element msg
box choices =
    column
        [ centerX
        , centerY
        , padding 30
        , spacing 200
        , Background.color (rgb255 255 255 255)
        , Border.rounded 10
        ]
        [progressSection, viewQuestion, (buttonRow choices)]


progressSection : Element msg
progressSection =
    row
        [ centerY
        , spacing 30
        , width fill
        ]
        [numericalProgress, progressBar, percentualProgress]

numericalProgress : Element msg
numericalProgress =
    el
        []
        (text "13 out of 15")

progressBar : Element msg
progressBar =
    el
        [ width (px 300)
        , height (px 30)
        , Background.color (rgb255 233 233 233)
        , Border.rounded 30
    ] (text "")


percentualProgress : Element msg
percentualProgress =
    el
        [] (text "87%")

viewQuestion : Element msg
viewQuestion =
    el
        [ alignTop
        , padding 30
        , centerX
        ]
        (text "Lorem ipsum dolor ember")

buttonRow : List String -> Element msg
buttonRow choices =
    row [width fill, centerY, centerX, spacing 30 ]
    (List.map viewButton choices)

viewButton : String -> Element msg
viewButton buttonText = Input.button
            [ Background.color(rgb255 233 233 233)
            , paddingEach
                { top = 20
                , right = 30
                , bottom = 20
                , left = 30
                }
            , Border.rounded 30
        ]
        { onPress = Nothing
        , label = Element.text buttonText
        }
