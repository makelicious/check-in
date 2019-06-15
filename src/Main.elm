port module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Url
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Element exposing (Element, el, text, row, column, alignRight, alignLeft, fill, width, rgb255, rgba, spacing, centerY, padding, centerX, centerY, alignTop, height, px, paddingEach, paddingXY)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Border as Border
import Element.Font as Font

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
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
    { currentQuestion : Maybe Question
    , questions : List Question
    , title : String
    , answeredQuestions : List AnsweredQuestion
    , url: Url.Url
    , key: Nav.Key
    }

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key
    = (
    { currentQuestion = Nothing
        , questions =
            [
                { question = "what is"
                , choices = ["yy kaa koo nee", "yy kaa koo nee", "yy kaa koo nee", "kaa koo nee vii", "koo nee vii kuu"]
                }
                ,
                { question = "where is"
                , choices = ["nee", "vii", "kuu"]
                }
            ]
        , title = "Good stuff"
        , answeredQuestions = []
        , key = key
        , url = url
    }, Cmd.none)



---- UPDATE ----


type Msg
    = NoOp
    | SaveAnswer AnsweredQuestion
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )
                Browser.External href ->
                    ( model, Nav.load href )
        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )
        SaveAnswer answer ->
            ( { model | answeredQuestions = answer :: model.answeredQuestions, questions = List.drop 1 model.questions }, Cmd.none)
        NoOp ->
            ( model, Cmd.none )



---- SUBSCRIPTIONS ----
subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    let
        viewRendered =
            case (List.head model.questions) of
                Nothing ->
                    (el [] (text "13 out of 15"))
                Just val ->
                    column [ width fill ]
                    [ (viewTitleWapper model.title)
                    , (viewWrapper model val)
                    ]
    in
    { title = "Check me outside"
    , body = [ Element.layout [
        Background.color (rgb255 255 255 255)
    ] viewRendered
    ]
    }

viewWrapper : Model -> Question -> Element Msg
viewWrapper model currentQuestion =
    column
        [ centerX
        , centerY
        ]
        [(viewContent model currentQuestion), (viewQuestionBox)]

viewTitleWapper : String -> Element Msg
viewTitleWapper title =
    el
        [ width fill
        , paddingXY 0 30
        , Font.color (rgb255 255 255 255)
        , Font.size 48
        , Background.color (rgb255 92 164 169)
        ]
        (viewTitle title)

viewTitle : String -> Element Msg
viewTitle title =
    el
        [ alignLeft, paddingXY 64 0]
        (text title)

viewContent : Model -> Question -> Element Msg
viewContent model question =
    column
        [ centerX
        , centerY
        , padding 64
        , spacing 32
        , Background.color (rgb255 255 255 255)
        , Border.rounded 10
        ]
        [(viewQuestionTitle question.question), (viewButtonRow question)]

viewQuestionTitle : String -> Element msg
viewQuestionTitle questionTitle =
    el
        [ alignTop
        , alignLeft
        , paddingXY 0 32
        , Font.size 32
        ]
        (text questionTitle)

viewQuestionBox : Element msg
viewQuestionBox =
    row
        [ alignTop
        , paddingEach
            { top = 0
            , right = 0
            , bottom = 32
            , left = 0
            }
        ][]

viewButtonRow : Question -> Element Msg
viewButtonRow question =
        row [width fill, centerY, centerX, spacing 30 ]
        (renderViewButtons question question.choices)

renderViewButtons : Question -> List String -> List (Element Msg)
renderViewButtons question choices =
    List.map (\choice -> Input.button
            [ Background.color (rgb255 209 227 229)
            , paddingXY 48 24
            , Border.rounded 8
            , Border.shadow
                { offset = (1, 2)
                , color = (rgba 0 0 0 0.2)
                , size = 1
                , blur = 3
                }
            , Element.mouseOver
                [ Background.color (rgb255 25 115 125)
                , Border.shadow
                    { offset = (0, 0)
                    , color = (rgba 0 0 0 0.0)
                    , size = 0
                    , blur = 0
                    }
                , Font.color (rgb255 255 255 255)
            ]
        ]
        { onPress = Just (SaveAnswer { choice = choice, question = question.question })
        , label = Element.text choice
        }
    ) choices
