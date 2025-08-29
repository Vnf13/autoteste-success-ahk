#SingleInstance Force
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows, On

; GUI de controle
Gui, Add, Text,, Automação de Testes - Estoque
Gui, Add, Button, vBtnIniciar gBotaoIniciar, Iniciar Teste
Gui, Show,, Controle de Teste
return

; Ação do botão Iniciar
BotaoIniciar:
    SetTimer, ExecutarTeste, 100
return

; Execução do teste em loop
ExecutarTeste:
    SetTimer, ExecutarTeste, Off

    Sleep, 1600
    Loop, 5 {
        ; Simulação de teclas com pausas ampliadas
        Send, {F8}
        Sleep, 1500

        SendInput, 35
        Sleep, 1500

        Send, {Enter}
        Sleep, 1500
        Send, {Enter}
        Sleep, 1500

        SendInput, 740
        Sleep, 1500

        Send, {Enter}
        Sleep, 1500
        Send, {Enter}
        Sleep, 1500
        Send, {Enter}
        Sleep, 1500
        Send, {Enter}
        Sleep, 1500
        Send, {Enter}
        Sleep, 1600

        SendInput, 727
        Sleep, 1500
        Send, {F8}
        Sleep, 1600

        Send, !f ; Alt + F
        Sleep, 1600

        SendInput, 0,40
        Sleep, 1900
        Send, {F8}
        Sleep, 2000

        Send, {F5}
        Sleep, 2000
    }

    MsgBox, Teste finalizado!
return

GuiClose:
ExitApp
