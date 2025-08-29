#Requires AutoHotkey v2.0

CriarGUI() {
    ; Cria a janela principal
    minhaGUI := Gui()
    minhaGUI.Opt("+MaximizeBox +MinimizeBox +Resize")
    minhaGUI.SetFont("s10", "Segoe UI")
    minhaGUI.Title := "AutoTeste - Geração e Fechamento de DAV"

    ; Criação da aba principal
    tab := minhaGUI.Add("Tab3", "x10 y10 w980 h680", ["Estoque"])

    ; === Conteúdo da aba "Estoque" ===
    tab.UseTab(1)

    ; Cabeçalho (Informações do Pedido)
    minhaGUI.Add("GroupBox", "x30 y50 w920 h130", "Cabeçalho do Pedido")

    minhaGUI.Add("Text", "x40 y80", "Vendedor:")
    global InputVendedor := minhaGUI.Add("Edit", "vInputVendedor w120", "35")

    minhaGUI.Add("Text", "x180 y80", "Cliente:")
    global InputCliente := minhaGUI.Add("Edit", "vInputCliente w180", "740")

    minhaGUI.Add("Text", "x40 y130", "Condição Pagamento:")
    global InputCondicao := minhaGUI.Add("Edit", "vInputCondicao w100", "01")

    minhaGUI.Add("Text", "x180 y130", "Forma Pagamento:")
    global InputFormapag := minhaGUI.Add("Edit", "vInputFormapag w100", "01")

    ; Itens
    minhaGUI.Add("GroupBox", "x30 y190 w920 h100", "Inclusão de Itens")

    minhaGUI.Add("Text", "x40 y220", "Item:")
    global InputItem := minhaGUI.Add("Edit", "vInputItem w100", "727")

    minhaGUI.Add("Text", "x160 y220", "Quantidade:")
    global InputQuantidadeItens := minhaGUI.Add("Edit", "vInputQuantidadeItens w80", "1")

    ; Totalização
    minhaGUI.Add("GroupBox", "x30 y300 w920 h100", "Totalização")

    minhaGUI.Add("Text", "x40 y330", "Valor Total:")
    global InputValorTotal := minhaGUI.Add("Edit", "vInputValorTotal w120", "0.40")

    minhaGUI.Add("Text", "x180 y330", "Qtde Formas Pagamento:")
    global InputFormasPagamento := minhaGUI.Add("Edit", "vInputFormasPagamento w80", "1")

    ; Cheque / Pagamento
    minhaGUI.Add("GroupBox", "x30 y410 w920 h160", "Dados para Cheque")

    minhaGUI.Add("Text", "x40 y440", "Banco:")
    global InputBanco := minhaGUI.Add("Edit", "vInputBanco w80", "756")

    minhaGUI.Add("Text", "x220 y440", "Agência:")
    global InputAgencia := minhaGUI.Add("Edit", "vInputAgencia w80", "111")

    minhaGUI.Add("Text", "x360 y440", "Conta Corrente:")
    global InputContaCorrente := minhaGUI.Add("Edit", "vInputContaCorrente w100", "111")

    minhaGUI.Add("Text", "x530 y440", "Nº Cheque:")
    global InputNumeroCheque := minhaGUI.Add("Edit", "vInputNumeroCheque w100", "111")

    minhaGUI.Add("Text", "x40 y490", "CNPJ/CPF:")
    global InputCNPJ := minhaGUI.Add("Edit", "vInputCNPJ w150", "05746902128")

    minhaGUI.Add("Text", "x220 y490", "Valor Cheque:")
    global InputValorCheque := minhaGUI.Add("Edit", "vInputValorCheque w100", "0.40")

    minhaGUI.Add("Text", "x360 y490", "Vencimento (dd/mm/aaaa):")
    global InputVencimento := minhaGUI.Add("Edit", "vInputVencimento w120", "18072026")

    ; Ações
    minhaGUI.Add("GroupBox", "x30 y580 w920 h60", "Ações")

    btnIniciar := minhaGUI.Add("Button", "x320 y600 w140 h30", "Iniciar Teste")
    btnIniciar.OnEvent("Click", BotaoIniciar)

    btnExportar := minhaGUI.Add("Button", "x500 y600 w140 h30", "Exportar Log")
    btnExportar.OnEvent("Click", ExportarLog)

    minhaGUI.OnEvent("Close", (*) => ExitApp())
    
    minhaGUI.Show("w1020 h720")
    return minhaGUI
}

; Exporta a função para criar a GUI
global minhaGUI := CriarGUI()