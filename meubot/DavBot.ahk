class DavBot {
    __New() {
        this.tempos := {
            curto: 300,
            medio: 1000,
            longo: 3000
        }
        
        this.telas := Map(
            "Pedido", TelaPedido,
            "Incluir", TelaIncluir,
            "Totalizacao", TelaTotalizacao,
            "Cheques", TelaCheques,
            "ContasReceber", TelaContasReceber
        )
        
        this.logs := []
    }
    
    ExecutarTeste(dados) {
        try {
            ; Implementação do fluxo principal
        } catch as e {
            throw Error("Erro na execução: " e.Message)
        }
    }
}