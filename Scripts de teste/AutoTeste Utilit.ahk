 ; Totalização
        WinActivate, Success - SISTEMAS GERENCIAL
        WinWaitActive, Success - SISTEMAS GERENCIAL,, 3
        Sleep, 500
        Send, {Alt down}lcs{Alt up}
        Sleep, 1000


        WinActivate, Parâmetros do Sistema
        WinWaitActive, Parâmetros do Sistema,, 3
        Sleep, 2800
        SendInput, 01
        Sleep, 500
        Send, {F8}