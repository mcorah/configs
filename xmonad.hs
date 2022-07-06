import XMonad
import XMonad.Config.Gnome
import XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Hooks.SetWMName

-- For stuff involving physical screens
-- import XMonad.Actions.PhysicalScreens

main = do
	xmonad $ gnomeConfig {
    layoutHook = myLayout,
    XMonad.workspaces=myWorkspaces,
    startupHook = startupHook gnomeConfig >> setWMName "LG3D"
    }`additionalKeysP` myKeys

-- names for the ten abstract desktops/workspaces
myWorkspaces=["1","2","3","4","5","6","7","8","9","0"]

myKeys=desktopKeys

desktopKeys=[ (otherModMasks ++ "M-" ++ [key], action tag)
             | (tag, key) <- zip myWorkspaces "1234567890"
             , (otherModMasks, action) <- [ ("",windows . W.greedyView)
                                             , ("S-", windows . W.shift)]
            ]

--
-- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
-- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
-- This avoids the issue that the screen numbering can be arbitrary and not
-- necessarily left to right.
--
-- screenKeys=[ (mask ++ "M-" ++ [key], action screen)
--             | (screen, key) <- zip [0..] "wer"
--            , (mask, action) <- [("", viewScreen), ("S-", sendToScreen)]
--           ]

-- workspace layout modes (fullscreen, etc.)
myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    Full) |||
    noBorders (fullscreenFull Full)
