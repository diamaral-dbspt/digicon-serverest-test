language: pt-br

*** Settings ***
Documentation        Passos referente ao cadastro de usuário

Library              SeleniumLibrary

*** Keywords ***
que acessei o sistema ServeRest
    Wait Until Element Is Visible
    ...    link: Cadastre-se   
    ...    timeout= 10s    
    ...    error= O sistema demora demais para carregar.

acessei a página de cadastro
    Click Link        Cadastre-se

preencho o formulário com meus dados
    [Arguments]        ${NOME}    ${EMAIL}    ${SENHA}

    Input Text        id: nome        ${NOME}
    Input Text        id: email       ${EMAIL}
    Input Password    id: password    ${SENHA}

marco o campo "administrador" se for o caso
    [Arguments]        ${EH_ADMINISTRADOR}

    Run Keyword If     ${EH_ADMINISTRADOR}
    ...    Click Element    id: administrador

submeto os dados
    Click Button      tag: button

devo ver a mensagem de sucesso na tela
    [Arguments]        ${MENSAGEM_ESPERADA}

    Wait Until Page Contains    
    ...    ${MENSAGEM_ESPERADA}
    ...    timeout=5s 
    ...    error=A mensagem de sucesso não foi exibida. Revise o cadastro.

    Capture Page Screenshot