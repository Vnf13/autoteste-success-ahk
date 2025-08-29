#SingleInstance Force
#Warn All, Off

; Verificação de versão
if (A_AhkVersion < "2.0") {
    MsgBox("Este script requer AutoHotkey v2.0+", "Versão Incompatível", "Icon!")
    ExitApp
}

; Includes (remova o *i se os arquivos são obrigatórios)
#Include GuiManager.ahk
#Include DavBot.ahk
#Include Telas\TelaBase.ahk
#Include Telas\TelaPedido.ahk
#Include Telas\TelaIncluir.ahk
#Include Telas\TelaTotalizacao.ahk
#Include Telas\TelaCheques.ahk
#Include Telas\TelaContasReceber.ahk

SetTitleMatchMode 2
DetectHiddenWindows True

global App := {
    name: "AutoTeste - Geração e Fechamento de DAV",
    version: "1.0",
    logEnabled: True
}

; Instanciação
try {
    global guiManager := GuiManager.new()
    global davBot := DavBot.new()
} catch as e {
    MsgBox("Falha ao instanciar classes: " e.Message, "Erro", "Icon!")
    ExitApp
}

; Verificação
if (!IsObject(guiManager)) {
    MsgBox("Falha ao criar GuiManager", "Erro", "Icon!")
    ExitApp
}

guiManager.ShowGui()

^!r::Reload
^!q::ExitApp