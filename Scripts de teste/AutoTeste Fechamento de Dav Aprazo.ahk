#SingleInstance Force
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows, On

global vendedor := ""
global cliente := ""
global item := ""
global totalizacaoLetra := ""
global repeticoes := 0
global log := ""
global pastaSistema := ""
global empresa := ""
global login := ""
global senha := ""

; Função para registrar log
Log(msg) {
    global log
    log .= msg . "`n"
}

; GUI
Gui, Add, Text,, Pasta do Sistema (pasta onde está success.exe):
Gui, Add, Edit, vInputPastaSistema w300
Gui, Add, Button, gSelecionarPasta, Selecionar Pasta...

Gui, Add, Text,, Código da Empresa:
Gui, Add, Edit, vInputEmpresa w100

Gui, Add, Text,, Login:
Gui, Add, Edit, vInputLogin w150

Gui, Add, Text,, Senha:
Gui, Add, Edit, vInputSenha w150 Password

Gui, Add, Text,, Código do Vendedor:
Gui, Add, Edit, vInputVendedor w150

Gui, Add, Text,, Código do Cliente:
Gui, Add, Edit, vInputCliente w150

Gui, Add, Text,, Código do Item:
Gui, Add, Edit, vInputItem w150

Gui, Add, Text,, Letra da Totalização (ex: E):
Gui, Add, Edit, vInputLetraTotalizacao w50

Gui, Add, Text,, Quantidade de Ciclos:
Gui, Add, Edit, vInputRepeticoes w50

Gui, Add, Button, gBotaoIniciar w120, Iniciar Teste
Gui, Add, Button, gExportarLog x+10 w120, Exportar Log

Gui, Add, Text, vStatusText w300, Aguardando início...
Gui, Show,, Automação de Testes - Totalização por Letra
return

SelecionarPasta:
    FileSelectFolder, selectedFolder, , 3, Selecione a pasta do sistema (onde está success.exe)
    if (selectedFolder != "")
    {
        GuiControl,, InputPastaSistema, %selectedFolder%
    }
return

; Botão: Iniciar Teste
BotaoIniciar:
    global vendedor, cliente, item, totalizacaoLetra, repeticoes, log
    global pastaSistema, empresa, login, senha

    Gui, Submit, NoHide
    vendedor := InputVendedor
    cliente := InputCliente
    item := InputItem
    totalizacaoLetra := InputLetraTotalizacao
    repeticoes := InputRepeticoes + 0
    pastaSistema := InputPastaSistema
    empresa := InputEmpresa
    login := InputLogin
    senha := InputSenha

    ; Validação
    if (pastaSistema = "") {
        MsgBox, 48, Erro, Por favor, preencha a pasta do sistema!
        return
    }
    if !FileExist(pastaSistema "\success.exe") {
        MsgBox, 48, Erro, Arquivo success.exe não encontrado na pasta informada!
        return
    }
    if (empresa = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código da Empresa!
        return
    }
    if (login = "") {
        MsgBox, 48, Erro, Por favor, preencha o Login!
        return
    }
    if (senha = "") {
        MsgBox, 48, Erro, Por favor, preencha a Senha!
        return
    }
    if (vendedor = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Vendedor!
        return
    }
    if (cliente = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Cliente!
        return
    }
    if (item = "") {
        MsgBox, 48, Erro, Por favor, preencha o Código do Item!
        return
    }
    if (totalizacaoLetra = "" or !RegExMatch(totalizacaoLetra, "^[A-Za-z]$")) {
        MsgBox, 48, Erro, Informe uma única letra válida para totalização (ex: E)
        return
    }
    if (repeticoes <= 0) {
        MsgBox, 48, Erro, Informe uma quantidade válida de ciclos (maior que 0)
        return
    }

    log := ""
    GuiControl,, StatusText, Iniciando aplicação...
    
    ; Executa o success.exe na pasta informada
    Run, %pastaSistema%\success.exe
    Sleep, 5000  ; Aguarda o programa abrir

    GuiControl,, StatusText, Teste em execução...
    SetTimer, ExecutarTeste, 100
return

; Loop de execução com login e teste
ExecutarTeste:
    SetTimer, ExecutarTeste, Off
    global vendedor, cliente, item, totalizacaoLetra, repeticoes, log
    global empresa, login, senha
    Sleep, 1500

    Loop, %repeticoes% {
        Log("Ciclo " . (A_Index) . ": Aguardando tela 'Success (Apresentação)'...")

        SetTitleMatchMode, 2
        Loop {
            IfWinActive, Success (Apresentação)
                break
            Sleep, 500
        }
        Sleep, 2000  ; espera extra para a animação carregar

        Log("Ciclo " . (A_Index) . ": Realizando login")

          SetTitleMatchMode, 2
        Loop {
            IfWinActive, Login (Interface Windows)
                break
            Sleep, 500
        }
        Sleep, 2000  ; espera extra para a animação carregar

        Send, {Enter}
        Sleep, 1000
        SendInput, %empresa%
        Sleep, 1000
        Send, {Enter}
        Sleep, 1000
        SendInput, %login%
        Sleep, 1000
         Loop, 2 {
         Send, {Enter}
         Sleep, 1000
        }
        Sleep, 1500
        Send, {F8}
        Sleep, 3000

        Loop, 3 {
         Send, {Enter}
         Sleep, 1000
        }

        Log("Ciclo " . (A_Index) . ": Aguardando tela 'Pedido'...")

        SetTitleMatchMode, 2
        Loop {
            IfWinActive, Pedido
                break
            Sleep, 500
        }
        Sleep, 4000  ; espera extra para garantir carregamento total da tela

        Log("Ciclo " . (A_Index) . ": Início")

        Send, {F8}
        Sleep, 1500
        SendInput, %vendedor%
        Sleep, 1500

        Loop, 2 {
            Send, {Enter}
            Sleep, 1500
        }

        SendInput, %cliente%
        Sleep, 1500

        Loop, 5 {
            Send, {Enter}
            Sleep, 1500
        }

        SendInput, %item%
        Sleep, 1500
        Send, {F8}
        Sleep, 1500

        ; Totalização
        WinActivate, Incluir
        WinWaitActive, Incluir,, 3
        Sleep, 300
        Send, {Alt down}f{Alt up}
        Sleep, 1500

        SendInput, %totalizacaoLetra%
        Sleep, 1500

        Send, {Raw}0,40
        Sleep, 1900
        Send, {F8}
        Sleep, 4000

        Send, {F5}
        Sleep, 2000

        Log("Ciclo " . (A_Index) . ": Concluído")
    }

    MsgBox, Teste finalizado com sucesso!
    Log("Total de ciclos concluídos: " . repeticoes)
    GuiControl,, StatusText, Teste finalizado!
return

; Exportar log
ExportarLog:
    global log
    FileSelectFile, filePath, S16, , Salvar log como, Arquivos de Texto (*.txt)
    if (filePath != "") {
        if !RegExMatch(filePath, "\.txt$") {
            filePath .= ".txt"
        }
        FileDelete, %filePath%
        FileAppend, %log%, %filePath%
        MsgBox, Log exportado com sucesso para:`n%filePath%
    }
return

GuiClose:
ExitApp
