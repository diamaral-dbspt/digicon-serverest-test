*** Settings ***

Documentation            Testes de Contrato - Consulta de Produtos

Resource                 ../../resources/configs/api.resource

Library                  ../../resources/libraries/contrato.py

Suite Setup              Abrir sessão na API
Suite Teardown           Delete All Sessions

*** Test Cases ***

Consulta de produtos respeita o contrato
    ${resp}=        GET On Session
    ...         serverest
    ...         /produtos  
    ...         expected_status=200

    Validar Lista Produtos
    ...        ${resp.json()}
    ...        ${CURDIR}/../../resources/schemas/consulta_produtos.json
    ...        ${CURDIR}/../../resources/schemas/produto.json

Consulta de produtos com filtro respeita o contrato

    ${filtros}=    Create Dictionary
    ...        nome=Leitor Academy lpmfgdad

    Log To Console    Filtros enviados: ${filtros}

    ${resp}=        GET On Session
    ...         serverest
    ...         /produtos  
    ...         params=${filtros}
    ...         expected_status=200

    Log To Console    URL solicitada: ${resp.url}

    Validar Lista Produtos
    ...        ${resp.json()}
    ...        ${CURDIR}/../../resources/schemas/consulta_produtos.json
    ...        ${CURDIR}/../../resources/schemas/produto.json

