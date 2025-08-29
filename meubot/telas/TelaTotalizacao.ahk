class TelaTotalizacao extends TelaBase {
    Operar(dados) {
        this.EsperarTela("Totaliza��o")
        
        ; Preencher valor total
        Send("{Raw}" dados["valorTotal"])
        Sleep(this.tempos.medio)
        
        ; Confirmar totaliza��o
        Send("{F8}")
        Sleep(this.tempos.longo)
        
        ; Verificar se precisa selecionar forma de pagamento
        if (dados.Has("formaPagamento")) {
            this.SelecionarFormaPagamento(dados["formaPagamento"])
        }
        
        davBot.AdicionarLog("Totaliza��o conclu�da - Valor: " dados["valorTotal"])
    }
    
    SelecionarFormaPagamento(formaPag) {
        if (WinExist("Selecionar Forma Pagamento")) {
            this.EsperarTela("Selecionar Forma Pagamento")
            SendInput(formaPag)
            Send("{Enter}")
            Sleep(this.tempos.medio)
        }
    }
}