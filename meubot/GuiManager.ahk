class GuiManager {
    ; Propriedades da classe
    gui := unset
    tabs := unset
    controls := unset
    
    __New() {
        ; Inicialização correta em AHK v2
        this.gui := Gui()
        this.tabs := Map()
        this.controls := Map()
        this.InitializeGui()
        ; Adicione este retorno explícito
        return this
    }
    
    InitializeGui() {
        ; Configurações da janela principal
        this.gui.Opt("+Resize +MinimizeBox +MaximizeBox")
        this.gui.SetFont("s10", "Segoe UI")
        this.gui.Title := App.name " v" App.version
        
        ; Cria abas principais
        this.tabs.main := this.gui.Add("Tab3", "x10 y10 w980 h680", ["Estoque", "Financeiro"])
        
        ; Conteúdo da aba Estoque
        this.gui.Tab := 1
        this.AddHeaderSection()
        this.AddItemsSection()
        this.AddPaymentSection()
        this.AddActionsSection()
        
        ; Conteúdo da aba Financeiro (se necessário)
        this.gui.Tab := 2
        ; this.AddFinancialSection()
    }
    
    AddHeaderSection() {
        ; Grupo: Cabeçalho do Pedido
        this.controls.gbHeader := this.gui.Add("GroupBox", "x20 y50 w940 h130", "Cabeçalho do Pedido")
        
        ; Vendedor
        this.gui.Add("Text", "x30 y80", "Vendedor:")
        this.controls.vendedor := this.gui.Add("Edit", "vInputVendedor x100 y78 w120", "35")
        
        ; Cliente
        this.gui.Add("Text", "x240 y80", "Cliente:")
        this.controls.cliente := this.gui.Add("Edit", "vInputCliente x300 y78 w180", "740")
        
        ; Condição Pagamento
        this.gui.Add("Text", "x30 y120", "Condição Pagamento:")
        this.controls.condicao := this.gui.Add("Edit", "vInputCondicao x150 y118 w100", "01")
        
        ; Forma Pagamento
        this.gui.Add("Text", "x270 y120", "Forma Pagamento:")
        this.controls.formapag := this.gui.Add("Edit", "vInputFormapag x380 y118 w100", "01")
    }
    
    AddItemsSection() {
        ; Grupo: Inclusão de Itens
        this.controls.gbItems := this.gui.Add("GroupBox", "x20 y190 w940 h100", "Inclusão de Itens")
        
        ; Item
        this.gui.Add("Text", "x30 y220", "Item:")
        this.controls.item := this.gui.Add("Edit", "vInputItem x80 y218 w100", "727")
        
        ; Quantidade
        this.gui.Add("Text", "x200 y220", "Quantidade:")
        this.controls.quantidade := this.gui.Add("Edit", "vInputQuantidade x280 y218 w80", "1")
    }
    
    AddPaymentSection() {
        ; Grupo: Totalização
        this.controls.gbPayment := this.gui.Add("GroupBox", "x20 y300 w940 h100", "Totalização")
        
        ; Valor Total
        this.gui.Add("Text", "x30 y330", "Valor Total:")
        this.controls.valorTotal := this.gui.Add("Edit", "vInputValorTotal x120 y328 w120", "0.40")
        
        ; Qtde Formas Pagamento
        this.gui.Add("Text", "x270 y330", "Qtde Formas Pagamento:")
        this.controls.formasPagamento := this.gui.Add("Edit", "vInputFormasPagamento x420 y328 w80", "1")
    }
    
    AddActionsSection() {
        ; Grupo: Ações
        this.controls.gbActions := this.gui.Add("GroupBox", "x20 y580 w940 h80", "Ações")
        
        ; Botão Iniciar Teste
        this.controls.btnIniciar := this.gui.Add("Button", "x320 y600 w140 h30", "Iniciar Teste")
        this.controls.btnIniciar.OnEvent("Click", (*) => this.BotaoIniciar())
        
        ; Botão Exportar Log
        this.controls.btnExportar := this.gui.Add("Button", "x500 y600 w140 h30", "Exportar Log")
        this.controls.btnExportar.OnEvent("Click", (*) => this.ExportarLog())
    }
    
    ShowGui() {
        this.gui.Show("w980 h700")
    }
    
    BotaoIniciar(*) {
        ; Coletar dados dos campos
        dados := Map(
            "vendedor", this.controls.vendedor.Value,
            "cliente", this.controls.cliente.Value,
            "item", this.controls.item.Value,
            "quantidadeItens", this.controls.quantidade.Value,
            "valorTotal", this.controls.valorTotal.Value,
            "formasPagamento", this.controls.formasPagamento.Value,
            "condicao", this.controls.condicao.Value,
            "formapag", this.controls.formapag.Value
        )
        
        ; Validação básica
        for field, value in dados {
            if (value == "") {
                MsgBox("Preencha todos os campos obrigatórios!", "Erro", "Icon!")
                return
            }
        }
        
        ; Chamar o bot principal
        try {
            resultado := davBot.ExecutarTeste(dados)
            MsgBox("Teste executado com sucesso!", "Resultado", "Iconi")
        } catch as e {
            MsgBox("Erro durante execução: " e.Message, "Erro", "Iconx")
        }
    }
    
    ExportarLog(*) {
        ; Implementar exportação de logs
        MsgBox("Funcionalidade de exportação será implementada aqui", "Info", "Iconi")
    }

    ; Exportação explícita da classe (necessário no AHK 2.0.19)
}

; Em vez disso, adicione APENAS isto no final:
global GuiManager := GuiManager