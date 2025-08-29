class TelaCheques extends TelaBase {
    Operar(dados) {
        this.EsperarTela("Cheques a Receber")
        
        ; Iniciar inclus�o de cheque
        Send("!i") ; Alt+i
        Sleep(this.tempos.medio)
        
        ; Preencher dados do cheque
        this.PreencherCampo("Banco:", dados["banco"])
        this.PreencherCampo("Ag�ncia:", dados["agencia"])
        this.PreencherCampo("Conta Corrente:", dados["contaCorrente"])
        this.PreencherCampo("N�mero Cheque:", dados["numeroCheque"])
        this.PreencherCampo("CNPJ/CPF:", dados["cnpjCpf"])
        this.PreencherCampo("Valor:", dados["valorCheque"])
        this.PreencherCampo("Vencimento:", dados["vencimento"])
        
        ; Finalizar opera��o
        Send("!e") ; Alt+e (Encerrar)
        Sleep(this.tempos.longo)
        
        davBot.AdicionarLog("Cheque inclu�do - N� " dados["numeroCheque"])
    }
    
    PreencherCampo(rotulo, valor) {
        try {
            ; Foco no campo (implementa��o depende do sistema alvo)
            Send("{Tab}")
            Sleep(this.tempos.curto)
            SendInput(valor)
            Send("{Enter}")
            Sleep(this.tempos.curto)
        } catch as e {
            throw Error("Falha ao preencher " rotulo ": " e.Message)
        }
    }
}