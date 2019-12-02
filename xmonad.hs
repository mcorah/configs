import XMonad
import XMonad.Config.Gnome
import XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Hooks.SetWMName

main = do
	xmonad $ gnomeConfig {
    layoutHook = myLayout,
    XMonad.workspaces=myWorkspaces,
    startupHook = startupHook gnomeConfig >> setWMName "LG3D"
    }`additionalKeysP` myKeys

myWorkspaces=["1","2","3","4","5","6","7","8","9","0"]

myKeys=[ (otherModMasks ++ "M-" ++ [key], action tag)
        | (tag, key) <- zip myWorkspaces "1234567890"
        , (otherModMasks, action) <- [ ("",windows . W.greedyView)
                                        , ("S-", windows . W.shift)]
       ]

myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    Full) |||
    noBorders (fullscreenFull Full)
