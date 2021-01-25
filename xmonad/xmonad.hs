import XMonad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import XMonad.Hooks.UrgencyHook
import XMonad.Util.NamedWindows
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog

import System.IO
import System.Exit
import Graphics.X11.ExtraTypes.XF86

myTerminal = "alacritty"

myModMask = mod4Mask

myBorderColor = "#59ecc4"

myFocusedBorderColor = "#9c4dd2"

myWorkspaces = ["1:Com", "2:Code", "3:Personal", "4", "5", "6"]

myAdditionalKeys = [ (( myModMask, xK_Return), spawn myTerminal)
    , ((myModMask .|. shiftMask, xK_q), kill)
    , ((myModMask .|. shiftMask, xK_Return), windows W.swapMaster)
    , ((mod1Mask, xK_F4), spawn "shutdown -P now")
    , ((mod1Mask .|. shiftMask, xK_F4), io (exitWith ExitSuccess))
    , ((myModMask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
    , ((myModMask .|. shiftMask, xK_s), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")
    , ((0, xF86XK_AudioLowerVolume   ), spawn "amixer set Master 2-")
    , ((0, xF86XK_AudioRaiseVolume   ), spawn "amixer set Master 2+")
    , ((0, xF86XK_AudioMute          ), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    ]

myManageHook = composeAll [
    className =? "Google-chrome" --> doShift "1:Com"
    , className =? "Gnome-control-center" --> doFloat
    ]


data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
         name     <- getName w
         Just idx <- fmap (W.findTag w) $ gets windowset
         safeSpawn "notify-send" [show name, "workspace " ++ idx]


main = do
    xmproc <- spawnPipe "xmobar ~/.xmobar/xmobarrc"

    xmonad $ withUrgencyHook LibNotifyUrgencyHook $ docks defaultConfig
        {
        manageHook = myManageHook <+> manageDocks
        , layoutHook = avoidStruts $ spacingRaw True (Border 0 10 10 10) True (Border 10 10 10 10) True $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "blue" "" . shorten 50
                }
        , modMask = mod4Mask  -- Rebind Mod to the Windows key
        , workspaces = myWorkspaces
        , normalBorderColor = myBorderColor
        , focusedBorderColor = myFocusedBorderColor
        } `additionalKeys` myAdditionalKeys