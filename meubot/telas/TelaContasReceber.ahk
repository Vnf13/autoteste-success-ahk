class TelaContasReceber extends TelaBase {
    Operar(dados) {
        this.EsperarTela("Contas a Receber")
        
        ; Confirmar contas a receber
        Send("{F8}")
        Sleep(this.tempos.longo)
        
        ; Se houver parcelamento
        if (dados.Has("parcelas") && dados["parcelas"] > 1) {
            this.ProcessarParcelamento(dados)
        }
        
        davBot.AdicionarLog("Contas a receber registradas")
    }
    
    ProcessarParcelamento(dados) {
        this.EsperarTela("Parcelamento")
        
        ; Preencher n�mero de parcelas
        SendInput(dados["parcelas"])
        Send("{Enter}")
        Sleep(this.tempos.medio)
        
        ; Confirmar valores (implementa��o pode variar)
        Loop dados["parcelas"] {
            Send("{Enter}")
            Sleep(this.tempos.curto)
        }
        
        davBot.AdicionarLog("Parcelamento em " dados["parcelas"] " vezes")
    }
}