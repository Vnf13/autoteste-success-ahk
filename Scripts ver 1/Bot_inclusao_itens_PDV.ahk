F2:: ; Atalho para iniciar o bot

Loop, 200 ; repete 200 vezes
{
    ; Digita o código (ajuste conforme necessário)
    Send, 450

    ; Pressiona Enter 3 vezes
    Send, {Enter}
    Send, {Enter}
    Send, {Enter}

    ; Espera 3 segundos
    Sleep, 3000
}

MsgBox, Processo concluído! Foram feitas 200 execuções.
return
