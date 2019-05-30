port module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Element exposing (Element, el, text, row, column, alignRight, fill, width, rgb255, spacing, centerY, padding, centerX, centerY, alignTop, height, px, paddingEach)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Border as Border

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
    { choices : List String
    , question : String
    }

type alias AnsweredQuestion =
    { question: String
    , choice: String
    }

type alias Model =
    { currentQuestion : Question
    , questions : List Question
    , title : String
    , answeredQuestions : List AnsweredQuestion
    }

init : ( Model, Cmd Msg )
init
    = (
    { currentQuestion =
        { question = "what"
        , choices = ["yy", "kaa", "koo"]
        }
        , questions =
            [
                { question = "what is"
                , choices = ["yy", "kaa", "koo"]
                }
                ,
                { question = "where is"
                , choices = ["nee", "vii", "kuu"]
                }
            ]
        , title = "Good stuff"
        , answeredQuestions = []
    }, Cmd.none)



---- UPDATE ----


type Msg
    = NoOp
    | SaveAnswer AnsweredQuestion


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SaveAnswer answer ->
            ( { model | answeredQuestions = answer :: model.answeredQuestions }, Cmd.none )
        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.layout [
        Background.color (rgb255 233 233 233)
    ]
    (viewWrapper model)

viewWrapper : Model -> Element Msg
viewWrapper model =
    column
        [ centerX
        , centerY
        ]
        [(viewTitle (model.title)), (viewContent (model.currentQuestion)), (viewQuestionBox)]

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

viewContent : Question -> Element Msg
viewContent question =
    column
        [ centerX
        , centerY
        , padding 30
        , spacing 200
        , Background.color (rgb255 255 255 255)
        , Border.rounded 10
        ]
        [viewProgressSection, (viewQuestionTitle question.question), (viewButtonRow question)]

viewQuestionTitle : String -> Element msg
viewQuestionTitle questionTitle =
    el
        [ alignTop
        , padding 30
        , centerX
        ]
        (text questionTitle)

viewQuestionBox : Element msg
viewQuestionBox =
    row
        [ alignTop
        , paddingEach
            { top = 0
            , right = 0
            , bottom = 30
            , left = 0
            }
        ][]

viewProgressSection : Element msg
viewProgressSection =
    row
        [ centerY
        , spacing 30
        , width fill
        ]
        [viewNumericalProgress, viewProgressBar, viewPercentualProgress]

viewNumericalProgress : Element msg
viewNumericalProgress =
    el
        []
        (text "13 out of 15")

viewProgressBar : Element msg
viewProgressBar =
    el
        [ width (px 300)
        , height (px 30)
        , Background.color (rgb255 233 233 233)
        , Border.rounded 30
    ] (text "")


viewPercentualProgress : Element msg
viewPercentualProgress =
    el
        [] (text "87%")

viewButtonRow : Question -> Element Msg
viewButtonRow question =
        row [width fill, centerY, centerX, spacing 30 ]
        (renderViewButtons question question.choices)

renderViewButtons : Question -> List String -> List (Element Msg)
renderViewButtons question choices =
    List.map (\choice -> Input.button
            [ Background.color(rgb255 233 233 233)
            , paddingEach
                { top = 20
                , right = 30
                , bottom = 20
                , left = 30
                }
            , Border.rounded 30
        ]
        { onPress = Just (SaveAnswer { choice = choice, question = question.question })
        , label = Element.text choice
        }
    ) choices
