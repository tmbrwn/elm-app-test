import Element exposing (Element, el, text, row)
import Element.Input exposing (button)
import Html exposing (Html)
import Browser
import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser as Url

main = Browser.application
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  , onUrlRequest = ClickedLink
  , onUrlChange = ChangePage << urlToPage
  }

-- MODEL
type alias Model =
  { page: Page
  , key: Nav.Key
  }

init : () -> Url -> Nav.Key -> (Model, Cmd Msg)
init () url key =
  ( { page = urlToPage url
    , key = key
    }
  , Cmd.none
  )

-- NAVIGATION
type Page
  = Landing
  | Search

urlToPage : Url -> Page
urlToPage url =
  case Url.parse urlParser url of
    Just page -> page
    Nothing -> Landing

urlParser = Url.oneOf
  [ Url.map Landing (Url.s "landing")
  , Url.map Search (Url.s "search")
  ]

-- VIEW
view : Model -> Browser.Document Msg
view model =
  { title = "SOUP"
  , body = [Element.layout [] (displayPage model)]
  }

displayPage : Model -> Element Msg
displayPage model =
  case model.page of
    Landing -> row []
      [ (text "Welcome to Internet!")
      , (button []
        { onPress = Just (ChangePage Search)
        , label = (text "Search!")
        })
      ]
    Search -> row []
      [ (text "You are not welcome at Internet!")
      , (button []
        { onPress = Just (ChangePage Landing)
        , label = (text "Land!")
        })
      ]


-- UPDATE
type Msg
  = ChangePage Page
  | ClickedLink Browser.UrlRequest

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangePage page -> ({ model | page = page }, Cmd.none)
    ClickedLink request ->
      case request of
        Browser.Internal url ->
          (model, Nav.pushUrl model.key (Url.toString url))
        Browser.External url ->
          (model, Nav.load url)


-- SUBS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

