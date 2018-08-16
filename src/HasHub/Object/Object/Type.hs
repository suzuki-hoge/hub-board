module HasHub.Object.Object.Type where


newtype EpicNumber = EpicNumber Int deriving (Eq, Show)


newtype EpicLinkNumber = EpicLinkNumber String deriving (Eq, Ord, Show)


data ParentEpicNumber = SharpEpicNumber String
                      | QuestionEpicNumber String
                      deriving (Eq, Ord, Show)


data LinkedEpic = LinkedEpic EpicLinkNumber EpicNumber deriving Show


data Epic = Epic EpicNumber Title deriving Show


newtype IssueNumber = IssueNumber Int deriving (Eq, Show)


newtype Title = Title String deriving (Eq, Show)


newtype Body = Body String deriving (Eq, Show)


newtype Estimate = Estimate Double deriving (Eq, Show)


_epicNumber :: IssueNumber -> EpicNumber
_epicNumber (IssueNumber n) = EpicNumber n


_number :: Epic -> EpicNumber
_number (Epic number _) = number


type LineNum = Int
type Definition = (LineNum, EpicLinkNumber)
type Parent = (LineNum, ParentEpicNumber)


findIn :: [LinkedEpic] -> ParentEpicNumber -> [EpicNumber]
findIn linkedEpics (SharpEpicNumber s) = [_toEpicNumber s]
findIn linkedEpics questionEpicNumber  = map _number filtered
  where
    filtered :: [LinkedEpic]
    filtered = filter (\(LinkedEpic epicLinkNumber _) -> epicLinkNumber ==? questionEpicNumber) linkedEpics

    _number :: LinkedEpic -> EpicNumber
    _number (LinkedEpic _ number) = number


_toEpicNumber :: String -> EpicNumber
_toEpicNumber s = EpicNumber $ (read . tail) s


(==?) :: EpicLinkNumber -> ParentEpicNumber -> Bool
(==?) (EpicLinkNumber eln) (QuestionEpicNumber qen) = eln == qen
