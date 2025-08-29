#SingleInstance Force
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows, On

global vendedor := ""
global cliente := ""
global item := ""
global totalizacaoLetra := ""
global repeticoes := 0
global log := ""
global formapag := ""

; Função para registrar log
Log(msg) {
    global log
    log .= msg . "`n"
}

; GUI
Gui, Add, Text,, Código do Vendedor:
Gui, Add, Edit, vInputVendedor w150
Gui, Add, Text,, Código do Cliente:
Gui, Add, Edit, vInputCliente w150
Gui, Add, Text,, Forma de Pagamento:
Gui, Add, Edit, vInputFormapag w50
Gui, Add, Text,, Código do Item:
Gui, Add, Edit, vInputItem w50
Gui, Add, Text,, Letra da Totalização (ex: E):
Gui, Add, Edit, vInputLetraTotalizacao w50
Gui, Add, Text,, Quantidade de Ciclos:
Gui, Add, Edit, vInputRepeticoes w50

Gui, Add, Button, gBotaoIniciar w120, Iniciar Teste
Gui, Add, Button, gExportarLog x+10 w120, Exportar Log

Gui, Add, Text, vStatusText w300, Aguardando início...
Gui, Show,, Automação de Testes - Totalização por Letra
return

; Botão: Iniciar Teste
BotaoIniciar:
    global vendedor, cliente, formapag, item, totalizacaoLetra, repeticoes, log
    Gui, Submit, NoHide
    vendedor := InputVendedor
    cliente := InputCliente
    formapag := InputFormapag
    item := InputItem
    totalizacaoLetra := InputLetraTotalizacao
    repeticoes := InputRepeticoes + 0

    ; Validação
    if (vendedor = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Vendedor!
        return
    }
    if (cliente = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Cliente!
        return
    }
    if (formapag = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código da Forma de Pagamento!
        return
    }
    if (item = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Item!
        return
    }
    if (totalizacaoLetra = "" or !RegExMatch(totalizacaoLetra, "^[A-Za-z]$")) {
        MsgBox, 48, Erro, Informe uma única letra válida para totalização (ex: E)
        return
    }
    if (repeticoes <= 0) {
        MsgBox, 48, Erro, Informe uma quantidade válida de ciclos (maior que 0)
        return
    }

    log := ""
    GuiControl,, StatusText, Teste em execução...
    SetTimer, ExecutarTeste, 100
return

; Loop de execução com totalização fixa via letra
ExecutarTeste:
    SetTimer, ExecutarTeste, Off
    global vendedor, cliente, formapag, item, totalizacaoLetra, repeticoes, log
    Sleep, 1000

    Loop, %repeticoes% {
        Log("Ciclo " . (A_Index) . ": Aguardando tela 'Pedido'...")

        SetTitleMatchMode, 2
        Loop {
            IfWinActive, Pedido
                break
            Sleep, 500
        }
        ; Espera extra para garantir carregamento total da tela
        Sleep, 4000

        Log("Ciclo " . (A_Index) . ": Início")

        Send, {F8}
        Sleep, 1000
        SendInput, %vendedor%
        Sleep, 1500

        Loop, 2 {
            Send, {Enter}
            Sleep, 1000
        }

        SendInput, %cliente%
        Sleep, 1000

        Loop, 2 {
            Send, {Enter}
            Sleep, 1000
        }

        SendInput, %formapag%

        Loop, 3 {
            Send, {Enter}
            Sleep, 1000
        }


        SendInput, %item%
        Sleep, 1000
        Send, {F8}
        Sleep, 1500

        ; Totalização
        WinActivate, Incluir
        WinWaitActive, Incluir,, 3
        Sleep, 300
        Send, {Alt down}f{Alt up}
        Sleep, 1000

        SendInput, %totalizacaoLetra%
        Sleep, 1000

        Send, {Raw}0,40
        Sleep, 1900
        Send, {F8}
        Sleep, 4000

       ; Verifica se a janela "Contas a Receber" surgiu
IfWinExist, Contas a Receber
{
    WinActivate, Contas a Receber
    WinWaitActive, Contas a Receber,, 3
    Sleep, 300
    Send, {F8}
    Sleep, 7000
}
else
{
    ; Caso não apareça, segue o fluxo normal
    Send, {F5}
    Sleep, 2000
}

        Send, {F5}
        Sleep, 2000

        Log("Ciclo " . (A_Index) . ": Concluído")
    }

    MsgBox, Teste finalizado com sucesso!
    Log("Total de ciclos concluídos: " . repeticoes)
    GuiControl,, StatusText, Teste finalizado!
return

; Exportar log
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
