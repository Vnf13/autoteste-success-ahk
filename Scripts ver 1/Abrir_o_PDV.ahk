F2:: ; Pressione F2 para iniciar

; Etapa 1: Executa o PDV.exe
Run, C:\empresas\cooper9\PDV.exe

; Etapa 2: Aguarda 5 segundos para o programa carregar (ajuste se necessário)
Sleep, 5000

; Etapa 3: Pressiona Enter 2 vezes
Send, {Enter}
Sleep, 500
Send, {Enter}
Sleep, 500

; Etapa 4: Digita o usuário
Send, ad
Sleep, 300
Send, {Enter}
Sleep, 500

; Etapa 5: Digita a senha
Send, sua_senha_aqui ; <-- Substitua por sua senha real
Sleep, 300

; Etapa 6: Pressiona F8 (botão OK)
Send, {F8}

MsgBox, Login automatizado concluído!
return
