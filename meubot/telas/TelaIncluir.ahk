class TelaIncluir extends TelaBase {
    Operar(dados) {
        this.EsperarTela("Incluir")
        
        Loop dados["quantidadeItens"] {
            SendInput(dados["item"])
            Sleep(this.tempos.medio)
            Send("{F8}")
            Sleep(this.tempos.longo)
        }
        
        davBot.AdicionarLog(dados["quantidadeItens"] " itens inclu�dos")
    }
}