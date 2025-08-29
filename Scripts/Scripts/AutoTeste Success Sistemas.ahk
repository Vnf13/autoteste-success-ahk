#SingleInstance Force
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows, On

global vendedor, cliente, condicao, item, valorTotal, quantidadeItens, formasPagamento
global formapag, banco, agencia, contacorrente, numerodocheque, cnpj_cpf, valor, vencimento
global logCompleto := ""

Gui, +MaximizeBox +MinimizeBox +Resize
Gui, Font, s10, Segoe UI

; Criação da aba principal
Gui, Add, Tab2, x10 y10 w980 h680, Estoque

; === Conteúdo da aba "Estoque" ===
Gui, Tab, 1

; Cabeçalho (Informações do Pedido)
Gui, Add, GroupBox, x30 y50 w920 h130, Cabeçalho do Pedido

Gui, Add, Text, x40 y80, Vendedor:
Gui, Add, Edit, vInputVendedor w120, 35

Gui, Add, Text, x180 y80, Cliente:
Gui, Add, Edit, vInputCliente w180, 740

Gui, Add, Text, x40 y130, Condição Pagamento:
Gui, Add, Edit, vInputCondicao w100, 01

Gui, Add, Text, x180 y130, Forma Pagamento:
Gui, Add, Edit, vInputFormapag w100, 01

; Itens
Gui, Add, GroupBox, x30 y190 w920 h100, Inclusão de Itens

Gui, Add, Text, x40 y220, Item:
Gui, Add, Edit, vInputItem w100, 727

Gui, Add, Text, x160 y220, Quantidade:
Gui, Add, Edit, vInputQuantidadeItens w80, 1

; Totalização
Gui, Add, GroupBox, x30 y300 w920 h100, Totalização

Gui, Add, Text, x40 y330, Valor Total:
Gui, Add, Edit, vInputValorTotal w120, 0,40

Gui, Add, Text, x180 y330, Qtde Opções de Pagamento Habilitado:
Gui, Add, Edit, vInputFormasPagamento w80, 1

; Cheque / Pagamento
Gui, Add, GroupBox, x30 y410 w920 h160, Dados para Cheque

Gui, Add, Text, x40 y440, Banco:
Gui, Add, Edit, vInputBanco w80, 756

Gui, Add, Text, x220 y440, Agência:
Gui, Add, Edit, vInputAgencia w80, 111

Gui, Add, Text, x360 y440, Conta Corrente:
Gui, Add, Edit, vInputContaCorrente w100, 111

Gui, Add, Text, x530 y440, Nº Cheque:
Gui, Add, Edit, vInputNumeroCheque w100, 111

Gui, Add, Text, x40 y490, CNPJ/CPF:
Gui, Add, Edit, vInputCNPJ w150, 05746902128

Gui, Add, Text, x220 y490, Valor Cheque:
Gui, Add, Edit, vInputValorCheque w100, 0,40

Gui, Add, Text, x360 y490, Vencimento (dd/mm/aaaa):
Gui, Add, Edit, vInputVencimento w120, 18072026

; Ações
Gui, Add, GroupBox, x30 y580 w920 h60, Ações

Gui, Add, Button, x320 y600 w140 h30 gBotaoIniciar, Iniciar Teste
Gui, Add, Button, x500 y600 w140 h30 gExportarLog, Exportar Log

Gui, Show, w1020 h720, AutoTeste - Geração e Fechamento de DAV
return

;Tela do Teste

; Botão Iniciar
BotaoIniciar:
    Gui, Submit, NoHide
    vendedor := InputVendedor
    cliente := InputCliente
    item := InputItem
    valorTotal := InputValorTotal
    quantidadeItens := InputQuantidadeItens
    condicao := InputCondicao
    formasPagamento := InputFormasPagamento
    formapag := InputFormapag         ; <-- captura a variável nova aqui
    banco := InputBanco
    agencia := InputAgencia
    contacorrente := InputContaCorrente
    numerodocheque := InputNumeroCheque
    cnpj_cpf := InputCNPJ
    valor := InputValorCheque
    vencimento := InputVencimento

    ; Validações
    if (vendedor = "" or cliente = "" or item = "" or valorTotal = "" or quantidadeItens = "" or formasPagamento = "" or condicao = "") {
    MsgBox, 48, Erro, Preencha todos os campos obrigatórios!
    return
    }

    if (!RegExMatch(quantidadeItens, "^\d+$") or !RegExMatch(formasPagamento, "^\d+$")) {
        MsgBox, 48, Erro, Quantidade de Itens e Formas de Pagamento devem ser números inteiros!
        return
    }

    ; Execução com base na quantidade de formas de pagamento
    Loop, %formasPagamento% {
        ciclo := A_Index
        logCompleto .= "Ciclo " . ciclo . ": Início`n"

        ; Criação do DAV
        WinActivate, Pedido
        WinWaitActive, Pedido,, 3
        Sleep, 300
        Send, {F8}
        Sleep, 1000

        ; Vendedor
        WinActivate, Pedido
        WinWaitActive, Pedido,, 3
        SendInput, %vendedor%
        Sleep, 500
        Loop, 2 {
            Send, {Enter}
            Sleep, 500
        }

        ; Cliente
        WinActivate, Pedido
        WinWaitActive, Pedido,, 3
        SendInput, %cliente%
        Sleep, 500
        Loop, 2 {
            Send, {Enter}
            Sleep, 400
        }

        SendInput, %formapag%
        Loop, 3 {
            Send, {Enter}
            Sleep, 400
        }

        ; Itens
        Loop, %quantidadeItens% {
            WinActivate, Incluir
            WinWaitActive, Incluir,, 3
            Sleep, 900
            SendInput, %item%
            Sleep, 900
            Send, {F8}
            Sleep, 1600
        }

        ; Totalização
        WinActivate, Incluir
        WinWaitActive, Incluir,, 3
        Sleep, 300
        Send, {Alt down}f{Alt up}
        Sleep, 1000

        ; Seleção da forma de pagamento
        WinActivate, Totalização
        WinWaitActive, Totalização,, 5
        downCount := ciclo - 1
        if (downCount > 0) {
            Send, {Down %downCount%}
            Sleep, 500
        }
         ; Totalização do pedido de venda
        WinActivate, Totalização
        WinWaitActive, Totalização,, 5
        Send, {RAW}%valorTotal%
        Sleep, 1900
        Send, {F8}0,40
        Sleep, 2000

        ; Cheque pré-datado
        IfWinExist, Cheques a Receber 
        {
            WinActivate, Cheques a Receber
            WinWaitActive, Cheques a Receber, 3
            Sleep, 900
            Send, {Alt down}i{Alt up}
            Sleep, 900
            WinActivate, Cheques a Receber
            WinWaitActive, Cheques a Receber, 3
            SendInput, %banco%
            WinActivate, Cheques a Receber
            WinWaitActive, Cheques a Receber, 3
            Send, {Enter}
            Sleep, 900
            SendInput, %agencia%
            Loop, 2{ 
                WinActivate, Cheques a Receber
                WinWaitActive, Cheques a Receber, 3
                Send, {Enter}
                Sleep, 900
            }
            SendInput, %contacorrente%
            Send, {Enter}
            Sleep, 900
            SendInput, %numerodocheque%
            Send, {Enter}
            Sleep, 900
            SendInput, %cnpj_cpf%
             Loop, 2{ 
                Send, {Enter}
                Sleep, 900
            }
            Send, {RAW}%valor%
            Send, {Enter}
            Sleep, 900
            SendInput, %vencimento%
            Loop, 2{
                Send, {Enter}
                Sleep, 900
            }
            Send, {Alt down}E{Alt up}
            Sleep, 2900
        } else {
        ;Se for fechado a prazo
        IfWinExist, Contas a Receber 
        {
            WinActivate, Contas a Receber
            WinWaitActive, Contas a Receber,, 3
            Sleep, 300
            Send, {F8}
            Sleep, 6900
        } 
        ;else {
       
      ;  }
        }
        WinActivate, Opções de Pedido
        WinWaitActive, Opções de Pedido,, 5
        Sleep, 300
        Send, {F5}
        Sleep, 500

        logCompleto .= "Ciclo " . ciclo . ": Concluído`n"
    }

    logCompleto .= "`nExecução finalizada com sucesso com " . formasPagamento . " ciclos.`n"
    MsgBox, Teste finalizado com sucesso!
return

; Exportar log
ExportarLog:
    FormatTime, timestamp, , yyyy-MM-dd_HH-mm-ss
    caminho := A_ScriptDir . "\log_execucao_" . timestamp . ".txt"
    FileAppend, %logCompleto%, %caminho%
    MsgBox, Log exportado com sucesso para:`n%caminho%
return

GuiClose:
ExitApp
