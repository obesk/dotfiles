-- TODO: modularize a bit and check dependencies
import Categories
-- import qualified XMonad.Actions.FlexibleResize as Flex
import qualified Data.Map as M
import XMonad.Actions.UpdatePointer
import Data.Maybe (fromMaybe)
import XMonad.Util.SpawnOnce
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.BoringWindows
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Magnifier
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.ThreeColumns
import XMonad.Layout.WindowNavigation
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import qualified XMonad.Util.ExtensibleState as XS
import XMonad.Util.Loggers
import XMonad.Util.NamedScratchpad
import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleFloat
import XMonad.Actions.CycleWS

term = "kitty"
browser = "firefox"
file_manager = "nautilus"

scratchpads =
  [ NS "htop" "kitty --class htop-scratch -- htop" (className =? "htop-scratch") myFloat,
    NS "thunar" "thunar --class thunar-scratch" (className =? "thunar-scratch") myFloat,
    NS "term" "kitty --class kitty-scratch" (className =? "kitty-scratch") myFloat,
    NS "notes" "flatpak run com.sublimetext.three" (className =? "Sublime_text") myFloat,
    NS "pulsemixer" (term ++ " --class pulsemixer -- pulsemixer") (className =? "pulsemixer") myFloat
  ]
  where
    myFloat = customFloating $ W.RationalRect (6 / 20) (3 / 20) (8 / 20) (14 / 20)

myLayout =
  showWName $
    spacing 4 $
      boringWindows $
        lessBorders Never $
          tabbed ||| threeCol ||| Full ||| simpleFloat
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    tabbed = windowNavigation $ subTabbed $ tiled
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

myManageHook =
  composeAll
    [ namedScratchpadManageHook scratchpads,
      fmap not willFloat --> insertPosition Below Newer
    ]

myStartupHook = 
    spawnOnce "feh --bg-center ~/.config/wall.jpg"
    -- TODO: figure out how to keep the keymap check
    -- return() >> checkKeymap myConfig myKeymap

myConfig =
  def
    { modMask = mod4Mask,
      layoutHook = myLayout,
      manageHook = myManageHook,
      workspaces = map show [1 .. (ws_per_category * categories + common_workpaces)],
      startupHook = myStartupHook,
      focusedBorderColor = "#ebe5da",
      normalBorderColor = "#403f3d",
      borderWidth = 2 
    }
    `removeMouseBindings` [
        ((mod4Mask, button1))
    ]
    `additionalMouseBindings` [
        ((mod4Mask, button1), mouseMoveWindow )
    ]
    `additionalKeysP` myKeymap

myKeymap =
  [ 
    -- ("M-S-Button1", \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster),
    -- ("M-Button3", \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster),
    ("M-;", spawn term),
    ("M-S-;", namedScratchpadAction scratchpads "term"),
    ("M-S-w", spawn browser),
    ("M-S-o", spawn "flatpak run md.obsidian.Obsidian"),
    ("M-S-c", spawn "code"),
    ("M-S-l", spawn "slock"),
    ("M-,", sendMessage FirstLayout),
    ("M-.", sendMessage NextLayout),
    ("M-q", kill),
    ("M-S-r", spawn "xmonad --recompile && xmonad --restart"),
    ("M-<L>", sendMessage $ pullGroup L),
    ("M-<R>", sendMessage $ pullGroup R),
    ("M-<U>", sendMessage $ pullGroup U),
    ("M-<D>", sendMessage $ pullGroup D),
    ("M-S-<U>", withFocused (sendMessage . MergeAll)),
    ("M-S-<D>", withFocused (sendMessage . UnMerge)),
    ("M-s", spawn "flameshot gui"),
    ("M-u", onGroup W.focusDown'),
    ("M-i", onGroup W.focusUp'),
    ("M-j", focusDown),
    ("M-k", focusUp),
    ("M-d", spawn "dmenu_run -i"),
    ("M--", spawn "pulsemixer --change-volume -5"),
    ("M-=", spawn "pulsemixer --change-volume +5"),
    ("M-S--", spawn "brightnessctl s 5%-"),
    ("M-S-=", spawn "brightnessctl s +5%"),
    ("M-m", spawn "pulsemixer --toggle-mute"),
    ("M-S-n", namedScratchpadAction scratchpads "notes"),
    ("M-S-p", namedScratchpadAction scratchpads "pulsemixer"),
    ("M-S-s", spawn "~/.screenlayout/\"$(ls -1 ~/.screenlayout/ | dmenu)\" && xmonad --restart"),
    ("M-<Space>", withFocused $ toggleFloating),
    ("M-S-h", namedScratchpadAction scratchpads "htop"),
    ("M-S-t", namedScratchpadAction scratchpads "thunar"),
    ("M-<Tab>", toggleWS' $ ["NSP"] ++ (map (show . (+ws_per_category * categories)) [1 .. common_workpaces])),
    ("M-`", (XS.modify' nextCategory) >> (focusWs 1))
  ]
    ++ [("M-" ++ (show i), focusWs i) | i <- normalWorkspaces] -- move between ws of the category
    ++ [("M-S-" ++ (show i), moveTo i) | i <- normalWorkspaces] -- move windows between ws of the categroy
    ++ [("M-" ++ (show i), focusCommon (i - ws_per_category)) | i <- [(ws_per_category + 1) .. 9]] -- move to commons ws
    ++ [("M-0", focusCommon 5)] -- adding the zero binding to above
    ++ [("M-S-" ++ (show i), moveToCommon (i - ws_per_category)) | i <- [(ws_per_category + 1) .. 9]] -- move windows to common ws
    ++ [("M-S-0", moveToCommon 5)] -- adding the zero binding to aboze
    ++ [("M-<F" ++ (show i) ++ ">", (XS.modify' $ \_ -> toEnum (i - 1) :: WsCategory) >> (focusWs 1)) | i <- [1 .. categories]] -- move between categories
    ++ [("M-S-<F" ++ (show i) ++ ">", applyToRelIndex (toEnum (i - 1) :: WsCategory) W.shift 1) | i <- [1 .. categories]] -- move windows between categories
  where
    normalWorkspaces = [1 .. ws_per_category]
    focusWs = applyIndex W.greedyView
    moveTo = applyIndex W.shift
    focusCommon = applyCommon W.greedyView
    moveToCommon = applyCommon W.shift

toggleFloating :: Window -> X ()
toggleFloating w = windows $ \s ->
  case M.member w (W.floating s) of
    True -> W.sink w s
    False -> W.float w (W.RationalRect 0.1 0.1 0.8 0.8) s

myXmobarPP :: PP
myXmobarPP =
  def
    { ppSep = magenta " • ",
      ppTitleSanitize = xmobarStrip,
      ppCurrent = wrap "[" "]" . (xmobarBorder "Bottom" "#8be9fd" 2) . displayCategory,
      ppVisible = wrap "<" ">" . displayCategory,
      ppHidden = wrap " " "" . displayCategory,
      -- ppHiddenNoWindows = lowWhite . wrap " " "",
      ppUrgent = red . wrap (yellow "!") (yellow "!"),
      ppOrder = \[ws, l, _, wins] -> [ws, l, wins],
      ppExtras = [logTitles formatFocused formatUnfocused]
    }
  where
    displayCategory "NSP" = "" -- hiding the scratchpad workspace
    displayCategory c = indexToName $ read c

    formatFocused = wrap (white "[") (white "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 40

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta = xmobarColor "#ff79c6" ""
    blue = xmobarColor "#bd93f9" ""
    white = xmobarColor "#f8f8f2" ""
    yellow = xmobarColor "#f1fa8c" ""
    red = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

main :: IO ()
main =
  xmonad
    . ewmhFullscreen
    . ewmh
    . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
    $ myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig {modMask = m} = (m, xK_b)
