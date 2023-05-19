---------------------------------------------------------------------------- 
-- IMPORTS
---------------------------------------------------------------------------- 

-- BASELINE
import Graphics.X11.ExtraTypes.XF86
import Control.Monad (liftM2)
import XMonad
import Data.Monoid
import System.Exit
import XMonad.Actions.SpawnOn

-- UTILITIES
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)

-- LAYOUT
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace

-- HOOKS
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog (xmobarPP
                               , ppOutput
                               , dynamicLogWithPP
                               , ppCurrent
                               , ppTitle
                               , ppHidden
                               , ppHiddenNoWindows
                               , ppVisible
                               , ppLayout
                               , xmobarColor
                               , shorten, wrap)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen )

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

---------------------------------------------------------------------------- 
-- VARIABLES
---------------------------------------------------------------------------- 
myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "kitty"

myBorderWidth :: Dimension
myBorderWidth = 4

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
myWorkspaces = ["dev", "web", "sys" ] ++ map show [4..9]

---------------------------------------------------------------------------- 
-- PROGRAMS
---------------------------------------------------------------------------- 
spawnOneScreenSetup = "xrandr --output DP3 --off"
spawnTwoScreenSetup = "xrandr --output DP3 --mode 2560x1440 --pos 3456x0"
spawnBackground = "feh --bg-scale /home/ellychan/Pictures/konpaku_youmu.jpg"
spawnScreenshot = "flameshot gui"

---------------------------------------------------------------------------- 
-- COLORS
---------------------------------------------------------------------------- 

myNormalBorderColor :: String
myNormalBorderColor  = "#404040"

myFocusedBorderColor :: String
myFocusedBorderColor = "#ffbbff"

-- xmobar colors
--colorAccentGreen = "#bbffdd"
colorAccentPurple = "#bbbbff"
colorAccentBlue = "#88ffff"
colorAccentPink = "#ffbbff"
colorAccentYellow = "#ffffbb"
colorAccentGreen = "#bbffbb"

---------------------------------------------------------------------------- 
-- KEYBINDINGS
---------------------------------------------------------------------------- 
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    --launch and close stuff
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf) -- launch a terminal
    , ((modm,               xK_d     ), spawn "rofi -modi drun -show drun -config ~/.config/rofi/rofidmenu.rasi") -- launch dmenu
    , ((modm,               xK_w     ), spawnOn "web" "firefox") -- launch firefox
    , ((modm,               xK_n     ), spawn "thunar") -- launch thunar
    , ((modm .|. shiftMask, xK_s     ), spawn spawnScreenshot)
    , ((modm .|. shiftMask, xK_c     ), kill) -- close focused window
    --, ((modm .|. shiftMask, 0xffc8   ), spawn "xrandr --output DP3 --scale 1x1 --mode 2560x1440 --pos 3456x0 --scale 1.5x1.5")
    , ((modm .|. shiftMask, xK_F11), spawn (spawnOneScreenSetup ++ " && " ++ spawnBackground))
    , ((modm .|. shiftMask, xK_F12), spawn (spawnTwoScreenSetup ++ " && " ++ spawnBackground))

    -- layout stuff
    , ((modm,               xK_space ), sendMessage NextLayout) -- Rotate through the available layout algorithms
    -- , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), withFocused $ windows . W.sink) -- Push window back into tiling
    , ((modm,               xK_b     ), refresh) -- Resize viewed windows to the correct size
    , ((modm,               xK_h     ), sendMessage Shrink) -- Shrink the master area
    , ((modm,               xK_l     ), sendMessage Expand) -- Expand the master area

    -- Move focus
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp  )
    , ((modm,               xK_m     ), windows W.focusMaster  ) -- Move focus to the master window
    , ((modm .|. shiftMask,               xK_Return), windows W.swapMaster) -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  ) -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    ) -- Swap the focused window with the previous window

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Quit or Restart xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    -- Media Keys
    , ((0, xF86XK_AudioMute), spawn "amixer -D pulse set Master toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q sset Master 5%-")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q sset Master 5%+") -- "<XF86AudioRaiseVolume>"

    -- Brightness control
    , ((0, xF86XK_MonBrightnessUp), spawn "/usr/bin/xbacklight -inc 10") --0x1008ff02
    , ((0, xF86XK_MonBrightnessDown), spawn "/usr/bin/xbacklight -dec 10") -- 0x1008ff03

    -- Print screenshot
    , ((0, xK_Print), spawn spawnScreenshot) -- "<Print>" xF86XK_ScreenSaver 0xff61

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{t,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{t,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
         | (key, sc) <- zip [xK_e, xK_r] [0..]
         , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
-- myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    -- [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
      --                                 >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    -- , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    -- , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
      --                                  >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    --]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
-- myLayout = onWorkspace "web" (noBorders Full) $ spacing 6 $ avoidStruts(gaps [(U,12), (R,12), (D, 12), (L, 12)] $ tiled ||| Mirror tiled ||| Full)
--myLayout = onWorkspace "web" (noBorders Full) $ avoidStruts(tiled  ||| Full)
myLayout = smartBorders $ avoidStruts(tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "thunderbird"    --> viewShift "8"
    , className =? "firefox"        --> viewShift "web"
    , className =? "discord"        --> viewShift "9"
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]
  where viewShift = doF . liftM2 (.) W.greedyView W.shift

------------------------------------------------------------------------
-- Event handling
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
--myEventHook = docksEventHook <+> handleEventHook def <+> fullscreenEventHook 
myEventHook =  handleEventHook def

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = ewmhDesktopsStartup >> setWMName "LG3D"

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawnOnce "feh --bg-scale /home/ellychan/Pictures/konpaku_youmu.jpg"
    --spawnOnce "xrandr --output DP3 --scale 1x1 --mode 2560x1440 --pos 3456x0 --scale 1.5x1.5"
    spawnOnce "sleep 1 && picom -CGb"
    spawnOnce "stalonetray"
    spawnOnce "nm-applet"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
--defaults = def {
main = do
  xmproc0 <- spawnPipe "xmobar -x 0 /home/ellychan/.config/xmobar/xmobarrc"
  xmonad $ ewmhFullscreen $ docks def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        -- mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = manageSpawn <+> myManageHook,
        startupHook        = myStartupHook >> setWMName "LG3D",
        handleEventHook    = handleEventHook def,
        --logHook            = dynamicLogWithPP $ def { ppOutput = \x -> hPutStrLn xmproc0 x }
        logHook            = dynamicLogWithPP xmobarPP { ppOutput = \x -> hPutStrLn xmproc0 x
                                                    , ppCurrent = xmobarColor colorAccentPink "" . wrap "[" "]"
                                                    , ppVisible = xmobarColor colorAccentPurple "" . wrap "<" ">"
                                                    , ppHidden = xmobarColor colorAccentYellow "" . wrap "*" ""
                                                    , ppHiddenNoWindows = xmobarColor colorAccentBlue ""
                                                    , ppTitle = shorten 50}
  }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'super'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
