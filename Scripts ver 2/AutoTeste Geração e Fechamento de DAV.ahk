#SingleInstance Force
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows, On

global vendedor := ""
global cliente := ""
global item := ""
global log := ""

; Função para registrar log com quebra de linha
Log(msg) {
    global log
    log .= msg . "`n"
}

; GUI com parâmetros, status e botões
Gui, Add, Text,, Código do Vendedor:
Gui, Add, Edit, vInputVendedor w150
Gui, Add, Text,, Código do Cliente:
Gui, Add, Edit, vInputCliente w150
Gui, Add, Text,, Código do Item:
Gui, Add, Edit, vInputItem w150

Gui, Add, Button, gBotaoIniciar w120, Iniciar Teste
Gui, Add, Button, gExportarLog x+10 w120, Exportar Log

Gui, Add, Text, vStatusText w300, Aguardando início...

Gui, Show,, Automação de Testes - Estoque
return

; Botão: Iniciar Teste
BotaoIniciar:
    global vendedor, cliente, item, log
    Gui, Submit, NoHide
    vendedor := InputVendedor
    cliente := InputCliente
    item := InputItem

    if (vendedor = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Vendedor!
        return
    }
    if (cliente = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Cliente!
        return
    }
    if (item = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Item!
        return
    }

    log := ""  ; Limpa o log anterior
    GuiControl,, StatusText, Teste em execução...
    SetTimer, ExecutarTeste, 100
return

; Loop de execução com parâmetros
ExecutarTeste:
    SetTimer, ExecutarTeste, Off
    global vendedor, cliente, item, log
    Sleep, 1500

    Loop, 5 {
        Log("Ciclo " . (A_Index) . ": Início")

        Send, {F8}
        Sleep, 1500
        ;Incluir Vendedor
        SendInput, %vendedor%
        Sleep, 1500

        Loop, 2 {
            Send, {Enter}
            Sleep, 1500
        }

        ;Incluir Cliente
        SendInput, %cliente%
        Sleep, 1500

        Loop, 5 {
            Send, {Enter}
            Sleep, 1500
        }

        ;Incluir item
        SendInput, %item%
        Sleep, 1500
        Send, {F8}
        Sleep, 1600

        ;Chamar a tela de totalização
        Send, !f ; Alt + F
        Sleep, 1500

         ; Totalização com variação entre as 5 formas
        downCount := A_Index - 1
        if (downCount > 0) {
          Send, {Down %downCount%}
          Sleep, 800
         }

        ;Totalização
        Send, {Raw}0,40
        Sleep, 1900
        Send, {F8}
        Sleep, 2000

        Send, {F5}
        Sleep, 2000

        Log("Ciclo " . (A_Index) . ": Concluído")
    }

    MsgBox, Teste finalizado com sucesso!
    Log("Total de ciclos concluídos: 5")
    GuiControl,, StatusText, Teste finalizado!
return

; Botão: Exportar Log
ExportarLog:
    global log
    FileSelectFile, filePath, S16, , Salvar log como, Arquivos de Texto (*.txt)
    if (filePath != "") {
        if !RegExMatch(filePath, "\.txt$") {
            filePath .= ".txt"
        }
        FileDelete, %filePath%
        FileAppend, %log%, %filePath%
        MsgBox, Log exportado com sucesso para:`n%filePath%
    }
return

GuiClose:
ExitApp
