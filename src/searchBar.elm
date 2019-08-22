

-- MODEL

type alias Model =
  { searchTerm: String
  , suggestionsOpen: Bool
  , suggestions: Suggestions
  }

type alias Suggestions =
  { first: List Asset
  , selected: Maybe Asset
  , last: List Asset
  }

type Asset = IdentityAsset Identity | HostAsset Host

type alias Identity =
  { identityId: String
  , name: String
  , department: String
  }

type alias Host =
  { hostId: String
  , hostName: String
  , ips: List String
  }

selectSuggestion : Suggestions -> Int -> Suggestions
selectSuggestion s i =
  { first = []
  , selected = Nothing
  , last = []
  }
