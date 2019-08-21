#include <ComboConstants.au3>
#include "UDF\_SimpleSystem_UDF.au3"
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <Misc.au3>
#include <Inet.au3>
#Include <WinAPIEx.au3>
#include <WinAPISys.au3>
#include <File.au3>

Global $sApp_Version = "0.1"
Global $sGame_Version = "10"

Global $info, $inGame
Global $findDeath = 0
Global $jumpedGood = 0
Global $gameCounter = 0
Global $globalx, $globaly
Global $g_bPaused = False

HotKeySet("{F3}", "Terminate")
HotKeySet("{F1}", "TogglePause")

_Info()
GUISetState(@SW_SHOW,$info)

Func _Info()
   #Region ### START Koda GUI section ### Form=
   $info = GUICreate("FortEx Bot 0.1", 330, 226, Default, Default)
   GUISetBkColor(0xFF8080)
   $Label1 = GUICtrlCreateLabel("Fortnite Bot v" & $sApp_Version, 0, 0, 327, 28, $SS_CENTER)
   GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
   GUICtrlSetColor(-1, 0xFFFF00)
   $Label2 = GUICtrlCreateLabel(">>> GITHUB <<<", 0, 24, 324, 17, $SS_CENTER)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   GUICtrlSetColor(-1, 0xFFFF00)
   $Group1 = GUICtrlCreateGroup("Control", 8, 40, 313, 177)
   $start = GUICtrlCreateButton("Start FortBot", 16, 184, 115, 25)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0xFF0080)
   $fixme = GUICtrlCreateButton("Configure game", 136, 184, 99, 25)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0xFF80C0)
   Global $status = GUICtrlCreateLabel("Not in game!", 64, 56, 138, 17, $SS_CENTER)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   GUICtrlSetColor(-1, 0xFFFFFF)
   $Label4 = GUICtrlCreateLabel("Status:", 24, 56, 48, 17)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $Label5 = GUICtrlCreateLabel("Required time to check status of the hero s.:", 24, 83, 253, 17)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   Global $checkTime = GUICtrlCreateInput("5", 280, 80, 33, 21)
   $Label6 = GUICtrlCreateLabel("Game mode:", 24, 158, 81, 17)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   Global $typeGame = GUICtrlCreateCombo("Passive mode ( just waiting )", 112, 155, 201, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
   GUICtrlSetData(-1, "Active mode ( jump in water )")
   GUICtrlSetColor(-1, 0xFF8080)
   $Label7 = GUICtrlCreateLabel("Games played:", 208, 56, 84, 17)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   Global $gameCL = GUICtrlCreateLabel("0", 296, 56, 11, 17)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   GUICtrlSetColor(-1, 0xFFFFFF)
   $keyButton = GUICtrlCreateButton("Unique Key", 240, 184, 75, 25)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   GUICtrlSetColor(-1, 0xFFFFFF)
   GUICtrlSetBkColor(-1, 0xFF0080)
   $Label3 = GUICtrlCreateLabel("Turn off after this number of games played:", 24, 110, 252, 17)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $gameClose = GUICtrlCreateInput("1", 280, 107, 33, 21)
   $Label8 = GUICtrlCreateLabel("F1 - Set the pause  |  F3 - Turn off FortBot", 25, 132, 200, 17)
   GUICtrlSetColor(-1, 0xFFD940)
   Global $ChecErr = GUICtrlCreateCheckbox("CheckConnErr", 225, 131, 85, 17)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   $Label9 = GUICtrlCreateLabel("Bot version: " & $sApp_Version, 8, 24, 90, 17)
   $Label10 = GUICtrlCreateLabel("Game version: " & $sGame_Version, 232, 24, 90, 17)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		   Case $GUI_EVENT_CLOSE
			   Exit
			Case $start
			   If WinExists("[TITLE:Fortnite]") Then
				  Global $hWnd = WinWait("[TITLE:Fortnite]", "", 5)
				  GUICtrlSetData($start, "Working!")
				  WinActivate($hWnd)
				  TryFortnite()
			   Else
				  MsgBox($MB_ICONINFORMATION, "Attention", "The game window is not found!", 0,0)
			   EndIf
			Case $fixme
			   If WinExists("[TITLE:Fortnite]") Then
				  Global $hWnd = WinWait("[TITLE:Fortnite]", "", 5)
				  WinActivate($hWnd)
				  WinMove($hWnd, "", 0, 0, 600, 600)
			   Else
				  MsgBox(0, "Attention", "The game window is not found!", 0,0)
			   EndIf
	   EndSwitch
	WEnd
EndFunc

Func Terminate()
    Exit
EndFunc   ;==>Terminate

Func TogglePause()
    $g_bPaused = Not $g_bPaused
    While $g_bPaused
        Sleep(500)
        GuiCtrlSetData($status, "On pause...")
    WEnd
    GuiCtrlSetData($status, "Continue!")
EndFunc   ;==>TogglePause

Func GetWinPos()
   If WinExists("[TITLE:Fortnite]") Then
	  Local $getpos = WinGetPos("[TITLE:Fortnite]")
	  Global $globalx = $getpos[0] ; X
	  Global $globaly = $getpos[1] ; Y
   EndIf
EndFunc

Func BotInit()
   GetWinPos()
   If WinExists("[TITLE:Fortnite]") Then
	  Global $hWnd = WinWait("[TITLE:Fortnite]", "", 5)
	  WinActivate($hWnd)
	  WinMove($hWnd, "", 0, 0, 600, 600)
	  GUICtrlSetData($status, "Updating variables")
	  $findDeath = 0
	  $jumpedGood = 0
	  $gameCounter += 1
	  GUICtrlSetData($gameCL, $gameCounter)
	  GUICtrlSetData($status, "Prepare to launch..")
	  Sleep(3000)
	  CheckInMenu()
   Else
	  MsgBox(0, "Attention", "The game window is not found!", 0,0)
   EndIf
EndFunc

Func FixMe()
   Global $hWnd = WinWait("[TITLE:Fortnite]", "", 5)
   WinActivate($hWnd)
   WinMove($hWnd, "", 0, 0, 600, 600)
EndFunc

Func CheckInMenu()
   GetWinPos()
   FixMe()
   MouseClick("left", 530+$globalx, 559+$globaly, 1)
   Sleep(3000)
   $inGame = 0
   Do
	  Local $CheckLobby  = PixelSearch(119+$globalx, 13+$globaly, 119+$globalx, 13+$globaly, 0xFCFCFC, 1)
	  If IsArray($CheckLobby) Then
		 GUICtrlSetData($status, "Still in lobby!")
		 Sleep(2000)
	  Else
		 GUICtrlSetData($status, "Enter the game...")
		 $inGame = 1
	  EndIf
   Until $inGame = 1
   Sleep(10000)
   Do
	  FixMe()
	  Local $CheckParachute  = PixelSearch(518+$globalx, 104+$globaly, 518+$globalx, 104+$globaly, 0x659F37, 5)
	  Local $CheckParachute2  = PixelSearch(518+$globalx, 96+$globaly, 518+$globalx, 96+$globaly, 0x659F37, 5)
	  Local $CheckParachute3  = PixelSearch(514+$globalx, 99+$globaly, 514+$globalx, 99+$globaly, 0x659F37, 5)
	  If IsArray($CheckParachute) Or IsArray($CheckParachute2) Or IsArray($CheckParachute3) Then
		 FixMe()
		 If GuiCtrlRead($typeGame) = "Active mode ( jump in water )" Then
			FixMe()
			Sleep(1000)
			GUICtrlSetData($status, "Waiting for final stop")
			Do
			   Local $CheckParachute  = PixelSearch(518+$globalx, 104+$globaly, 518+$globalx, 104+$globaly, 0x659F37, 5)
			   Local $CheckParachute2  = PixelSearch(518+$globalx, 96+$globaly, 518+$globalx, 96+$globaly, 0x659F37, 5)
			   Local $CheckParachute3  = PixelSearch(514+$globalx, 99+$globaly, 514+$globalx, 99+$globaly, 0x659F37, 5)
			   If Not IsArray($CheckParachute) Or Not IsArray($CheckParachute2) Or Not IsArray($CheckParachute3) Then
				  FixMe()
				  WinActivate($hWnd)
				  GUICtrlSetData($status, "Jump in water!")
				  Send("w")
				  Send("{w down}")
				  Sleep(60000)
				  Send("{w up}")
				  $jumpedGood = 1
			   EndIf
			Until $jumpedGood = 1
		 Else
			FixMe()
			GUICtrlSetData($status, "Sleep until jump")
			Sleep(15000) ; спим 15 секунд и прыгает в центре карты
			Send ("{SPACE}")
			$jumpedGood = 1
			GUICtrlSetData($status, "Go go go!")
			Sleep(95000)
			Send ("^")
		 EndIf
	  Else
		 FixMe()
		 Sleep(1000)
		 GUICtrlSetData($status, "Still not in bus!")
	  EndIf
   Until $jumpedGood = 1
   Do ; проверяем на смерть
	  FixMe()
	  Local $CheckDeath  = PixelSearch(71+$globalx, 34+$globaly, 71+$globalx, 34+$globaly, 0xFF0016, 20)
	  Local $CheckDeath2  = PixelSearch(72+$globalx, 31+$globaly, 72+$globalx, 31+$globaly, 0xFF0016, 20)
	  Local $CheckDeath3  = PixelSearch(71+$globalx, 34+$globaly, 71+$globalx, 34+$globaly, 0xEF0C24, 20)
	  Local $CheckDeath4  = PixelSearch(71+$globalx, 34+$globaly, 71+$globalx, 34+$globaly, 0xFD0118, 20)
	  Local $CheckDeathAround  = PixelSearch(4+$globalx, 21+$globaly, 136+$globalx, 54+$globaly, 0xFF0016, 20)
	  Local $CheckDeathAround2  = PixelSearch(4+$globalx, 21+$globaly, 136+$globalx, 54+$globaly, 0xEF0C24, 20)
	  Local $CheckDeathAround3  = PixelSearch(4+$globalx, 21+$globaly, 136+$globalx, 54+$globaly, 0xFD0118, 20)
	  Local $CheckDeathAround4  = PixelSearch(4+$globalx, 21+$globaly, 136+$globalx, 54+$globaly, 0xFB0319, 20)
	  If IsArray($CheckDeath) Or IsArray($CheckDeath2) Or IsArray($CheckDeath3) Or IsArray($CheckDeath4) Or IsArray($CheckDeathAround) Or IsArray($CheckDeathAround2) Or IsArray($CheckDeathAround3) Or IsArray($CheckDeathAround4) Then
		 Sleep(3000)
		 GUICtrlSetData($status, "Hero killed!")
		 $findDeath = 1
	  Else
		 FixMe()
		 GUICtrlSetData($status, "Check hero..")
		 Sleep(1000)
		 GUICtrlSetData($status, "Hero is alive, waiting..")
		 Sleep(GuiCtrlRead($checkTime) * 1000)
	  EndIf
   Until $findDeath = 1
   ConsoleWrite(123)
   FixMe()
   Sleep(3000)
   GUICtrlSetData($status, "Leave the game..")
   MouseClick("left", 558+$globalx, 589+$globaly, 3, 20)
   Sleep(2000)
   FixMe()
   GUICtrlSetData($status, "Wait a little bit..")
   Sleep(10000)
   Local $AddFriendNotify  = PixelSearch(181+$globalx, 323+$globaly, 181+$globalx, 323+$globaly, 0xFFF500, 20)
   If IsArray($AddFriendNotify) Then
	  MouseClick(495+$globalx, 573+$globaly)
   EndIf
   FixMe()
   Local $CheckLevelUp  = PixelSearch(300+$globalx, 496+$globaly, 300+$globalx, 496+$globaly, 0x243170, 10) ; скип экрана повышения
   If IsArray($CheckLevelUp) Then
	  MouseClick("left",300,496,1)
   EndIf
   botInit()
EndFunc




