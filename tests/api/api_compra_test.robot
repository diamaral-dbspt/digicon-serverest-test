*** Settings ***
Documentation       Teste ponta a ponta - Compra pela API

Resource            ../../resources/configs/api.resource

Suite Setup         Abrir sessão na API
Suite Teardown      Delete All Sessions


*** Test Cases ***

Compra de um produto pela API
    [Tags]    api    e2e    compra

    VAR    ${id}    ${EMPTY}
    VAR    ${compra_concluida}    ${False}

    ${headers}=    Criar administrador e obter token

    TRY

        GROUP    Preparar massa

            ${produto}=    Gerar produto

            ${resp}=    POST On Session
            ...    serverest
            ...    /produtos
            ...    json=${produto}
            ...    headers=${headers}
            ...    expected_status=201

            ${id}=    Set Variable    ${resp.json()}[_id]

            Aguardar produto disponível    ${id}

        END

        GROUP    Executar compra

            &{item}=    Create Dictionary
            ...    idProduto=${id}
            ...    quantidade=${1}

            @{itens}=    Create List    ${item}

            &{carrinho}=    Create Dictionary
            ...    produtos=${itens}

            ${resp_compra}=    POST On Session
            ...    serverest
            ...    /carrinhos
            ...    json=${carrinho}
            ...    headers=${headers}
            ...    expected_status=201

        END

        GROUP    Concluir compra

            ${resp_final}=    DELETE On Session
            ...    serverest
            ...    /carrinhos/concluir-compra
            ...    headers=${headers}
            ...    expected_status=200

            ${compra_concluida}=    Set Variable    ${True}

        END

    FINALLY

        GROUP    Limpar massa de dados

            IF    $id != ''

                IF    not $compra_concluida

                    TRY
                        DELETE On Session
                        ...    serverest
                        ...    /carrinhos/concluir-compra
                        ...    headers=${headers}
                        ...    expected_status=any

                    EXCEPT
                        Log    Não foi possível limpar o carrinho    WARN
                    END

                END

                Excluir produto se possível    ${id}    ${headers}

            END

        END

    END