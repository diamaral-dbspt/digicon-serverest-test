*** Settings ***

Library        RequestsLibrary
Library        Collections

Resource       dados.resource

*** Variables ***
${API}        https://serverest.dev

*** Keywords ***
Abrir sessão na API
    Create Session    serverest    ${API}    verify=${True}
 
Criar usuário com credenciais
    [Arguments]    ${administrador}=true

    ${usuario}=    Gerar usuário

    Set To Dictionary
    ...    ${usuario}
    ...    administrador=${administrador}

    ${resp_cadastro}=    POST On Session
    ...    serverest
    ...    /usuarios
    ...    json=${usuario}
    ...    expected_status=201

    ${login}=    Create Dictionary
    ...    email=${usuario}[email]
    ...    password=${usuario}[password]

    ${resp_login}=    POST On Session
    ...    serverest
    ...    /login
    ...    json=${login}
    ...    expected_status=200

    ${token}=    Set Variable    ${resp_login.json()}[authorization]

    ${headers}=    Create Dictionary
    ...    Authorization=${token}

    RETURN    ${usuario}    ${headers}
 
Criar Administrador Com Credenciais
    ${usuario}    ${headers}=    Criar Usuário Com Credenciais    true
    RETURN    ${usuario}    ${headers}
 
Criar administrador e obter token
    ${usuario}    ${headers}=    Criar usuário com credenciais    true
    RETURN    ${headers}
 
Excluir E Confirmar Exclusão
    [Arguments]    ${id}    ${headers}

    DELETE On Session
    ...    serverest
    ...    /produtos/${id}
    ...    headers=${headers}
    ...    expected_status=200

    ${resp}=    GET On Session
    ...    serverest
    ...    /produtos/${id}
    ...    expected_status=400

    Should Be Equal
    ...    ${resp.json()}[message]
    ...    Produto não encontrado

Executar Limpeza Do Produto
    [Arguments]    ${id}    ${headers}

    IF    $id is not None
        Excluir E Confirmar Exclusão    ${id}    ${headers}
    END