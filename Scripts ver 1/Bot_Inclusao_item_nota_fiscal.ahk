F2:: ; Quando pressionar F2, começa o bot cript AutoHotkey - Loop infinito até o script ser encerrado


Loop , 499
{
    ; Digita o código
    Send, 7893371070214

    ; Pressiona a tecla F8
    Send, {F8}

    ; Aguarda 3 segundos antes de repetir (ajuste se necessário)
    Sleep, 3000
}
