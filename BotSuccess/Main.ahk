#Requires AutoHotkey v2.0
#SingleInstance Force

; Inclui a GUI e os testes
#Include GUI.ahk
;#Include testes\CriarDAV.ahk
;#Include testes\IncluirItem.ahk
;#Include testes\TotalizarDAV.ahk
;#Include testes\CriarCheque.ahk
;#Include testes\CriarTitulo.ahk
;#Include testes\OpcoesPedido.ahk

; Variáveis globais
global vendedor, cliente, condicao, item, valorTotal, quantidadeItens, formasPagamento
global formapag, banco, agencia, contacorrente, numerodocheque, cnpj_cpf, valor, vencimento
global logCompleto := ""
global tempoCurto := 300, tempoMedio := 1000, tempoLongo := 3000

; Função do botão Iniciar
BotaoIniciar(*)
{
    global
    ; Obter valores dos campos
    vendedor := InputVendedor.Value
    cliente := InputCliente.Value
    item := InputItem.Value
    valorTotal := InputValorTotal.Value
    quantidadeItens := InputQuantidadeItens.Value
    condicao := InputCondicao.Value
    formasPagamento := InputFormasPagamento.Value
    formapag := InputFormapag.Value
    banco := InputBanco.Value
    agencia := InputAgencia.Value
    contacorrente := InputContaCorrente.Value
    numerodocheque := InputNumeroCheque.Value
    cnpj_cpf := InputCNPJ.Value
    valor := InputValorCheque.Value
    vencimento := InputVencimento.Value

    ; Validações
    if (vendedor = "" || cliente = "" || item = "" || valorTotal = "" || 
        quantidadeItens = "" || formasPagamento = "" || condicao = "") 
    {
        MsgBox("Preencha todos os campos obrigatórios!", "Erro", "Icon!")
        return
    }

    if (!RegExMatch(quantidadeItens, "^\d+$") || !RegExMatch(formasPagamento, "^\d+$")) 
    {
        MsgBox("Quantidade de Itens e Formas de Pagamento devem ser números inteiros!", "Erro", "Icon!")
        return
    }

    ; Execução principal
    Loop(formasPagamento) {
        ciclo := A_Index
        logCompleto .= "Ciclo " ciclo ": Início`n"
        
        if (!CriarDAV()) {
            MsgBox("Falha ao criar DAV", "Erro", "Icon!")
            return
        }
        
        if (!IncluirItens()) {
            MsgBox("Falha ao incluir itens", "Erro", "Icon!")
            return
        }
        
        if (!TotalizarDAV()) {
            MsgBox("Falha ao totalizar", "Erro", "Icon!")
            return
        }
        
        if (WinExist("Cheques a Receber")) {
            if (!CriarCheque()) {
                MsgBox("Falha ao criar cheque", "Erro", "Icon!")
                return
            }
        } 
        else if (WinExist("Contas a Receber")) {
            if (!CriarTitulo()) {
                MsgBox("Falha ao criar título", "Erro", "Icon!")
                return
            }
        }
        
        if (!FinalizarPedido()) {
            MsgBox("Falha ao finalizar pedido", "Erro", "Icon!")
            return
        }
        
        logCompleto .= "Ciclo " ciclo ": Concluído`n"
    }
    
    MsgBox("Teste finalizado com sucesso!", , "Iconi")
}

ExportarLog(*)
{
    global
    timestamp := FormatTime(, "yyyy-MM-dd_HH-mm-ss")
    caminho := A_ScriptDir "\log_execucao_" timestamp ".txt"
    FileAppend(logCompleto, caminho)
    MsgBox("Log exportado com sucesso para:`n" caminho, , "Iconi")
}

; Hotkeys
^!r::Reload
^!q::ExitApp