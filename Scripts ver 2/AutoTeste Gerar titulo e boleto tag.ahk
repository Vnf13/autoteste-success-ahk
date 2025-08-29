#SingleInstance Force
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows, On

global cliente := ""
global vendedor := ""
global valor := ""
global condicaoPagamento := ""
global formaPagamento := ""
global repeticoes := 0
global log := ""

; Fun��o para registrar log
Log(msg) {
    global log
    log .= msg . "`n"
}

; GUI
Gui, Add, Text,, Código do Cliente:
Gui, Add, Edit, vInputCliente w150, 740
Gui, Add, Text,, Código do Vendedor:
Gui, Add, Edit, vInputVendedor w150, 34
Gui, Add, Text,, Valor do Titulo:
Gui, Add, Edit, vInputValor w100, 1500
Gui, Add, Text,, Forma de Pagamento (ex: 01):
Gui, Add, Edit, vInputFormaPagamento w50, 08
Gui, Add, Text,, Condição de Pagamento (ex: 14):
Gui, Add, Edit, vInputCondicaoPagamento w50, 42
Gui, Add, Text,, Quantidade de Ciclos:
Gui, Add, Edit, vInputRepeticoes w50, 5

Gui, Add, Button, gBotaoIniciar w120, Iniciar Teste
Gui, Add, Button, gExportarLog x+10 w120, Exportar Log

Gui, Add, Text, vStatusText w300, Aguardando inicio...
Gui, Show,, Automação de Testes - Geração de Titulo
return

; Bot�o: Iniciar Teste
BotaoIniciar:
    global cliente, vendedor, valor, condicaoPagamento, formaPagamento, repeticoes, log
    Gui, Submit, NoHide

    cliente := InputCliente
    vendedor := InputVendedor
    valor := InputValor
    formaPagamento := InputFormaPagamento
    condicaoPagamento := InputCondicaoPagamento
    repeticoes := InputRepeticoes + 0

    ; Valida��es
    if (cliente = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Cliente!
        return
    }
    if (vendedor = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Vendedor!
        return
    }
    if (valor = "" or !RegExMatch(valor, "^\d+([.,]\d{1,2})?$")) {
        MsgBox, 48, Erro, Preencha um valor valido para o Titulo (ex: 1000 ou 1000,00)
        return
    }
    if (formaPagamento = "" or !RegExMatch(formaPagamento, "^\d{2}$")) {
        MsgBox, 48, Erro, Informe um codigo valido de 2 digitos para Forma de Pagamento (ex: 01)
        return
    }
    if (condicaoPagamento = "" or !RegExMatch(condicaoPagamento, "^\d{2}$")) {
        MsgBox, 48, Erro, Informe um codigo valido de 2 digitos para Condicão de Pagamento (ex: 14)
        return
    }
    if (repeticoes <= 0) {
        MsgBox, 48, Erro, Informe uma quantidade valida de ciclos (maior que 0)
        return
    }

    log := ""
    GuiControl,, StatusText, Teste em execução...
    SetTimer, ExecutarTeste, 100
return

; Execu��o dos ciclos
ExecutarTeste:
    SetTimer, ExecutarTeste, Off
    global cliente, vendedor, valor, condicaoPagamento, formaPagamento, repeticoes, log
    Sleep, 900

    Loop, %repeticoes% {
        Log("Ciclo " . A_Index . ": Aguardando m�dulo 'Financeiro'...")

       ; Loop {
           ; IfWinActive, SUCCESS -
           ;     break
          ;  Sleep, 500
       ; }

        Sleep, 100  ; Garantir carregamento
        Log("Ciclo " . A_Index . ": Iniciando a��es")

        ; Aqui Começa seu fluxo real
        ;Send, {Alt down}lrt{Alt up}
        ;Sleep, 1000

        ; TODO: Preencher os campos e gerar o Titulo aqui conforme necessario
         IfWinExist, Contas a Receber 
        {
        Send, {F8}
        Sleep, 900
        SendInput, %cliente%
        Sleep, 900

        Loop, 2 {
        Send, {Enter}
        Sleep, 900
        }

        SendInput, %vendedor%
        Sleep, 900
        Send, {Enter}
        Sleep, 900

        SendInput, %valor%
        Sleep, 900
          Loop, 2 {
        Send, {Enter}
        Sleep, 900
        }

        SendInput, %condicaoPagamento%
        Sleep, 900
         Loop, 2 {
        Send, {Enter}
        Sleep, 900
        }

        SendInput, %formaPagamento%
        Sleep, 900
        Send, {Enter}
        Sleep, 900

        Send, {F8}
        Sleep, 900

        Send, "b"
        Sleep, 2500
        Send, {F8}
        Sleep, 2500

        Send, {F8}
        Sleep, 900

        Send, {Esc}
        Sleep, 2000

        Loop, 2{
        Send, {F5}
        Sleep, 900
        }
        }
    }

    MsgBox, Teste finalizado com sucesso!
    Log("Total de ciclos concluidos: " . repeticoes)
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
