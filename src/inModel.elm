import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    { selection : Field Selection
    , name : Field Int
    }


type Field field
    = Blank
    | Invalid String
    | Filled field


type Selection
    = Nope
    | Yep
    | Meh


enterSelection : String -> Field Selection
enterSelection str =
    case str |> String.trim |> String.toLower of
        "nope" ->
            Filled Nope

        "yep" ->
            Filled Yep

        "meh" ->
            Filled Meh

        "" ->
            Blank

        selection ->
            Invalid selection


enterName : String -> Field Int
enterName str =
    case ( str, str |> String.trim |> String.toInt ) of
        ( _, Just num ) ->
            Filled num

        ( "", _ ) ->
            Blank

        ( notNum, Nothing ) ->
            Invalid notNum


init : Model
init =
    { selection = Blank
    , name = Blank
    }



-- UPDATE


type Msg
    = UpdateSelection String
    | UpdateName String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateSelection selection ->
            { model | selection = enterSelection selection }

        UpdateName name ->
            { model | name = enterName name }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input
            [ onInput UpdateSelection
            , validationBackground model.selection
            ]
            []
        , input
            [ onInput UpdateName
            , validationBackground model.name
            ]
            []
        , div [] [ model |> operator |> text ]
        ]


validationBackground : Field f -> Html.Attribute msg
validationBackground field =
    let
        backgroundColor =
            style "background"
    in
    case field of
        Filled _ ->
            backgroundColor "lightBlue"

        Blank ->
            backgroundColor "white"

        Invalid _ ->
            backgroundColor "pink"


printSelection : Selection -> String
printSelection s =
    case s of
        Nope ->
            "SNONS"

        Yep ->
            "spaceship!"

        Meh ->
            "maybe!"


type alias Operands t =
    { t | selection : Field Selection, name : Field Int }


operator : Operands t -> String
operator model =
    case ( model.selection, model.name ) of
        ( Filled selection, Filled times ) ->
            String.repeat times (printSelection selection)

        ( Invalid _, Invalid _ ) ->
            "Invalid operands"

        ( Invalid _, _ ) ->
            "Invalid selection"

        ( _, Invalid _ ) ->
            "Invalid name"

        ( _, _ ) ->
            "Enter a string and a number of times to repeat it!"
