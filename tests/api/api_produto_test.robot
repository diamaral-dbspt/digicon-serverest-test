*** Settings ***
Documentation            Testes de API - Cadastro de Produto

Resource                 ../../resources/configs/api.resource

Suite Setup              Abrir sessão na API
Suite Teardown           Delete All Sessions

*** Test Cases ***

Administrador cadastra produto
    
    ${headers}=     Criar administrador e obter token
    ${produto}=     Gerar produto

    ${resp}=        POST On Session
    ...         serverest
    ...         /produtos    
    ...         json=${produto}
    ...         headers=${headers}
    ...         expected_status=201

    Should Be Equal
    ...        ${resp.json()}[message]
    ...        Cadastro realizado com sucesso

    Should Not Be Empty        ${resp.json()}[_id]

Cadastro de produto sem token é recusado

    ${produto}=     Gerar produto

    ${resp}=        POST On Session
    ...         serverest
    ...         /produtos
    ...         json=${produto}
    ...         expected_status=401

    Should Be Equal
    ...         ${resp.json()}[message]
    ...         Token de acesso ausente, inválido, expirado ou usuário do token não existe mais 

