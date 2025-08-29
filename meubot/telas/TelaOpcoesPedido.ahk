class TelaOpcoesPedido extends TelaBase {
    Operar(dados) {
        this.EsperarTela("Op��es de Pedido")
        
        ; Finalizar pedido (F5)
        this.EnviarComando("{F5}", "Finalizando pedido")
        Sleep(this.tempos.longo)
        
        ; Tratar poss�veis mensagens de confirma��o
        if (WinExist("Confirmar")) {
            this.EnviarComando("{Enter}", "Confirmando opera��o")
            Sleep(this.tempos.medio)
        }
        
        davBot.AdicionarLog("Pedido finalizado com sucesso")
    }
}