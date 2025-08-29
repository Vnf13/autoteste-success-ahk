class TelaPedido extends TelaBase {
    Operar(dados) {
        this.EsperarTela("Pedido")
        
        ; Fluxo de opera��o na tela de pedido
        Send("{F8}")
        Sleep(this.tempos.medio)
        
        ; Preencher vendedor
        SendInput(dados["vendedor"])
        Sleep(this.tempos.curto)
        Loop 2 {
            Send("{Enter}")
            Sleep(this.tempos.curto)
        }
        
        ; ... resto da implementa��o
        davBot.AdicionarLog("Tela Pedido operada com sucesso")
    }
}