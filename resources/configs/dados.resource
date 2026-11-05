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