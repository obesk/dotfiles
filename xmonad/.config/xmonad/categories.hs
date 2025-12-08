module Categories where

import XMonad
import qualified XMonad.StackSet as W
import qualified XMonad.Util.ExtensibleState as XS

-- the common category is a special category accessible with the remaining number
-- if i have 5 ws per category the common category ws are accessible by the 6-0 keys
-- Common should always be the last
data WsCategory = Blue | Red | Yellow | Special
  deriving (Eq, Ord, Read, Typeable, Bounded, Enum)

instance Show WsCategory where
  show Blue = "1🔵"
  show Red = "2🎲"
  show Yellow = "3🟡"
  show Special = "🌟"

instance ExtensionClass WsCategory where
  initialValue = minBound :: WsCategory

ws_per_category :: Int
ws_per_category = 4

-- counting one less category to exclude the Common from the "normal" categories
categories :: Int
categories = fromEnum (maxBound :: WsCategory)

common_workpaces :: Int
common_workpaces = 10 - ws_per_category

-- applies a function to the passed common workspace
applyCommon :: (String -> WindowSet -> WindowSet) -> Int -> X()
applyCommon = applyToRelIndex Special

--applies a function to the passed relative index
applyIndex :: (String -> WindowSet -> WindowSet) -> Int -> X()
applyIndex f i = XS.get >>= \cat -> applyToRelIndex cat f i 

-- applies a function to the ws on a passed category
applyToRelIndex :: WsCategory -> (String -> WindowSet -> WindowSet) -> Int -> X()
applyToRelIndex c f i = windows $ f $ show (getAbsIndex i c)

-- get the absolute index of the ws based on the category and relative index
getAbsIndex :: Int -> WsCategory -> Int
getAbsIndex i c = (fromEnum c) * ws_per_category + i

moveToCategory :: Int -> X ()
moveToCategory i = do
  windows $ W.shift $ show ((i - 1) * ws_per_category + 1)

nextCategory :: WsCategory -> WsCategory
nextCategory cat 
  | cat == toEnum (categories - 1) = minBound
  | otherwise = succ cat 


-- this function is needed to visualize the icon of the ws based on its absolute index
indexToName :: Int -> String
indexToName i = cat_name ++ " " ++ show_num rel_i 
  where
    -- FIXME: there has to be a cleaner way to do this
    (tmp_cat_num, tmp_rel_i) = divMod (i - 1) ws_per_category
    cat_num = min tmp_cat_num categories
    rel_i = i - cat_num * ws_per_category - 1
    cat_name = show (toEnum cat_num :: WsCategory)
    show_num num
      | cat_num == categories = show $ num + ws_per_category + 1
      | otherwise = show $ num + 1
