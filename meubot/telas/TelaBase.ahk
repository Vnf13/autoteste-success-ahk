class TelaBase {
    __New() {
        this.tempos := davBot.tempos
    }
    
    EsperarTela(titulo, timeout := 3) {
        try {
            WinWaitActive(titulo,, timeout)
        } catch {
            throw Error("Tela não encontrada: " titulo)
        }
    }
    
    Operar(dados) {
        throw Error("Método Operar() deve ser implementado")
    }
}