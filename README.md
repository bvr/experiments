
What is it
===========

Various experiment scripts, mostly perl. Some written by me, some from internet.


Autohotkey helper to create them
---------------------------------

When the .ahk script is active, copy snippet into clipboard, press Win+Shift+P,
type base of filename and confirm with Enter. The script will be created
in `C:\Dev\experiments\scripts` directory, named `YYYY-MM-DD-basename`
and opened in SciTE editor. If there is no suffix specified, automatically adds
`.pl`.

    ; quick test script
    +#p::
        Gui, Add, Text,x10 y10, Base name:
        Gui, Add, Edit, y7 x+10 w100 vFileName,%1%
        Gui, Add, Button, y6 x+5 w50 default, OK
        Gui, Show,, Quick test script
    Return

    ButtonOK:
        Gui, Submit     ; Save the input from the user to each control's associated variable.
        Gui, Destroy
        RunOrActivateProgram("C:\Util\Scite\Scite.exe")
        FormatTime, CurDate,, yyyy-MM-dd
        if not instr(FileName, ".")
            FileName = %FileName%.pl
        Send ^n+^sC:\Dev\experiments\scripts\%CurDate%-%FileName%{Enter}+{Ins}
    Return

    GuiClose:
    GuiEscape:
        Gui, Destroy
    Return

    ; Function to run a program or activate an already running instance
    RunOrActivateProgram(Program, WorkingDir="", WindowSize="") {
        SplitPath Program, ExeFile
        Process, Exist, %ExeFile%
        PID = %ErrorLevel%
        if (PID = 0) {
            Run, %Program%, %WorkingDir%, %WindowSize%, PID
            WinWait, ahk_pid %PID%, , 10        ; wait maximum 10s
        }

        ; one of process windows is already active, cycle
        IfWinActive, ahk_pid %PID%
        {
            WinActivateBottom, ahk_pid %PID%
            return
        }
        WinActivate, ahk_pid %PID%
    }
