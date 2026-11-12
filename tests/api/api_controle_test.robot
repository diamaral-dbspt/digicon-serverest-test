*** Settings ***
Documentation       Testes de controle da API

Resource            ../../resources/configs/api.resource

Suite Setup         Abrir sessão na API
Suite Teardown      Delete All Sessions


*** Test Cases ***

Todos os produtos em estoque têm preço positivo
    [Tags]    api    controle    produtos

    ${resp}=    GET On Session
    ...    serverest
    ...    /produtos
    ...    expected_status=200

    ${produtos}=    Set Variable    ${resp.json()}[produtos]
    ${verificados}=    Set Variable    ${0}

    FOR    ${produto}    IN    @{produtos}

        IF    ${produto}[quantidade] == 0
            CONTINUE
        END

        Should Be True
        ...    ${produto}[preco] > 0
        ...    Produto ${produto}[nome] com preço inválido

        ${verificados}=    Evaluate    ${verificados} + 1

    END

    Should Be True
    ...    ${verificados} > 0
    ...    Nenhum produto com estoque disponível foi encontrado

Cadastrar vários produtos com sucesso

    ${headers}=        Criar administrador e obter token
    ${total}=          Set Variable    ${5}
    
    FOR    ${i}    IN RANGE    ${total}
        ${produto}=        Gerar produto

        ${resp}=         POST On Session
        ...        serverest
        ...        /produtos
        ...        json=${produto}
        ...        headers=${headers}
        ...        expected_status=201        
    END
    