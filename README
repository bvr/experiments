
What is it
===========

Various experiments with perl. Some written by me, some from internet.


Autohotkey helper to create them
---------------------------------

When the .ahk script is active, copy snippet into clipboard, press Win+Shift+P,
type base of filename and confirm with Enter. The script will be created
in `D:\Dev\perl\experiments\scripts` directory, named `YYYY-MM-DD-basename.pl`
and opened in SciTE editor.

    ; quick test perl
    +#p::
        Gui, Add, Text,x10 y10, Base name:
        Gui, Add, Edit, y7 x+10 w100 vPerlFileName,%1%
        Gui, Add, Button, y6 x+5 w50 default, OK
        Gui, Show,, Perl quick test file
    Return

    ButtonOK:
        Gui, Submit     ; Save the input from the user to each control's associated variable.
        Gui, Destroy
        title = ahk_class SciTEWindow
        exe   = D:\Prog\Scite\Scite.exe
        GoSub,ActivateOrRun
        FormatTime, CurDate,, yyyy-MM-dd
        Send ^n+^sD:\Dev\perl\experiments\scripts\%CurDate%-%PerlFileName%.pl{Enter}+{Ins}
    Return

    GuiClose:
    GuiEscape:
        Gui, Destroy
    Return
