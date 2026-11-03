language: pt-BR

*** Configurações ***
Biblioteca          SeleniumLibrary

Recurso          ../../resources/configs/qa.resource

Test Setup       Open Browser    ${URL}    ${BROWSER}
Test Teardown    Close Browser

Test Tags        login
Test Template    Login deve ser recusado

 
*** Casos De Teste ***      EMAIL               SENHA        MENSAGEM
Senha incorreta             eu@dev.com          errada123    Email e/ou senha inválidos
Email não cadastrado        nada@academy.dev    Senha123     Email e/ou senha inválidos
Email vazio		            ${EMPTY}            admin123     Email é obrigatório
Senha vazio		            paul@dev.pt         ${EMPTY}     Password é obrigatório
 

*** Palavras-Chave ***
Login deve ser recusado
    [Arguments]      ${EMAIL}        ${SENHA}       ${MENSAGEM}
    
    Input Text       id: email       ${EMAIL}
    Input Password   id: password    ${SENHA}
    Click Button     xpath: //button[text() = 'Entrar'] 
    Wait Until Page Contains         ${MENSAGEM}    timeout=10s
