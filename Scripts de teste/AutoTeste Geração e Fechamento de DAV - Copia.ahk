#SingleInstance Force
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows, On

; Variáveis globais
global vendedor, cliente, item, valorTotal, quantidadeItens, formasPagamento
global banco, agencia, contacorrente, numerodocheque, cnpj_cpf, valor, vencimento
global logCompleto := ""

; GUI de controle
Gui, +MaximizeBox +MinimizeBox +Resize  ; Habilita os botões de maximizar, minimizar e redimensionar
Gui, Add, Text,, Vendedor:
Gui, Add, Edit, vInputVendedor w100

Gui, Add, Text,, Cliente:
Gui, Add, Edit, vInputCliente w100

Gui, Add, Text,, Forma de Pagamento:
Gui, Add, Edit, vInputFormapag w100

Gui, Add, Text,, Item:
Gui, Add, Edit, vInputItem w100

Gui, Add, Text,, Valor Total:
Gui, Add, Edit, vInputValorTotal w100

Gui, Add, Text,, Quantidade de Itens:
Gui, Add, Edit, vInputQuantidadeItens w100

Gui, Add, Text,, Quantidade de Formas de Pagamento:
Gui, Add, Edit, vInputFormasPagamento w100

Gui, Add, Text,, Banco:
Gui, Add, Edit, vInputBanco w100

Gui, Add, Text,, Agência:
Gui, Add, Edit, vInputAgencia w100

Gui, Add, Text,, Conta Corrente:
Gui, Add, Edit, vInputContaCorrente w100

Gui, Add, Text,, Nº do Cheque:
Gui, Add, Edit, vInputNumeroCheque w100

Gui, Add, Text,, CNPJ/CPF:
Gui, Add, Edit, vInputCNPJ w100

Gui, Add, Text,, Valor do Cheque:
Gui, Add, Edit, vInputValorCheque w100

Gui, Add, Text,, Vencimento (dd/mm/aaaa):
Gui, Add, Edit, vInputVencimento w100

Gui, Add, Button, gBotaoIniciar, Iniciar Teste
Gui, Add, Button, gExportarLog, Exportar Log
Gui, Show, Maximize, Controle de Teste

return

; Botão Iniciar
BotaoIniciar:
    Gui, Submit, NoHide
    vendedor := InputVendedor
    cliente := InputCliente
    item := InputItem
    valorTotal := InputValorTotal
    quantidadeItens := InputQuantidadeItens
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
    if (vendedor = "" or cliente = "" or item = "" or valorTotal = "" or quantidadeItens = "" or formasPagamento = "") {
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
        Send, {F8}
        Sleep, 1500

        ; Vendedor
        SendInput, %vendedor%
        Sleep, 1500
        Loop, 2 {
            Send, {Enter}
            Sleep, 1500
        }

        ; Cliente
        SendInput, %cliente%
        Sleep, 1500
        Loop, 2 {
            Send, {Enter}
            Sleep, 1000
        }

        SendInput, %formapag%
        Loop, 3 {
            Send, {Enter}
            Sleep, 1000
        }


        ; Itens
        Loop, %quantidadeItens% {
            WinActivate, Incluir
            WinWaitActive, Incluir,, 3
            SendInput, %item%
            Sleep, 1500
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
            Sleep, 800
        }

        ; Cheque pré-datado
        IfWinExist, Cheques a Receber 
        {
            WinActivate, Cheques a Receber
            WinWaitActive, Cheques a Receber, 3
            Sleep, 300
            Send, {Alt down}i{Alt up}
            Sleep, 300
            SendInput, %banco%
            Send, {Enter}
            Sleep, 300
            SendInput, %agencia%
            Send, {Enter}
            Sleep, 300
            SendInput, %contacorrente%
            Send, {Enter}
            Sleep, 300
            SendInput, %numerodocheque%
            Send, {Enter}
            Sleep, 300
            SendInput, %cnpj_cpf%
            Send, {Enter}
            Sleep, 300
            SendInput, %banco%
            Send, {Enter}
            Sleep, 300
            Send, {RAW}%valor%
            Send, {Enter}
            Sleep, 300
            SendInput, %vencimento%
            Send, {Enter}
            Sleep, 7000
        } else {
            Send, {F5}
            Sleep, 2000
        }

        ; Totalização do pedido de venda
        WinActivate, Totalização
        WinWaitActive, Totalização,, 5
        Send, {RAW}%valorTotal%
        Sleep, 1900
        Send, {F8}
        Sleep, 2000

        ;Se for fechado a prazo
        IfWinExist, Contas a Receber 
        {
            WinActivate, Contas a Receber
            WinWaitActive, Contas a Receber,, 3
            Sleep, 300
            Send, {F8}
            Sleep, 7000
        } else {
            Send, {F5}
            Sleep, 2000
        }

        WinActivate, Opções de Pedido
        WinWaitActive, Opções de Pedido,, 3
        Sleep, 300
        Send, {F5}
        Sleep, 2000
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
