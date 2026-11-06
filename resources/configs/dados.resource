*** Settings ***

Library        FakerLibrary        locale=pt_BR
Library        String

*** Keywords ***
Gerar Usuário
    ${nome}=        FakerLibrary.Name
    ${login}=       Generate Random String    10    [LOWER]
    ${senha}=       Generate Random String    12    [LETTERS][NUMBERS]
    ${usuario}=     Create Dictionary
    ...        nome=${nome}
    ...        email=${login}@academy.dev
    ...        password=${senha}

    RETURN    ${usuario}
    
Gerar produto
    ${sufixo}=     Generate Random String    8    [LOWER]
    
    VAR    &{produto}    nome=Leitor Academy ${sufixo}    preco=${150}
    ...    descricao=Leitor de cartão para testes    quantidade=${10}
    RETURN    ${produto}