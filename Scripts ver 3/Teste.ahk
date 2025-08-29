#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

Gui, Color, 2C3E50  ; Cor de fundo (azul escuro)
Gui, Font, cWhite s10, Segoe UI
Gui, Add, Text,, Teste com fundo customizado
Gui, Add, Button, gBotao1 Background00AA00 cWhite, Clique aqui
Gui, Show,, Interface Customizada
return

Botao1:
MsgBox, Você clicou no botão!
return

GuiClose:
ExitApp
