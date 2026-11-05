*** Settings ***

Library        DatabaseLibrary

Resource       dados.resource

*** Keywords ***
Preparar base de dados
    Connect To Database        sqlite3
    ...    database=${CURDIR}/../../data/massa.db
    ...    isolation_level=${none}

    ${sql}=    Catenate    SEPARATOR=${SPACE}
    ...    CREATE TABLE IF NOT EXISTS usuarios_teste (
    ...    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ...    email TEXT NOT NULL UNIQUE,
    ...    senha TEXT NOT NULL,
    ...    perfil TEXT NOT NULL,
    ...    criado_em TEXT DEFAULT (datetime('now'))
    ...    )

    Execute Sql String    ${sql}

Registrar Usuário No Banco
    [Arguments]    ${usuario}    ${perfil}

    @{parametros}=    Create List
    ...    ${usuario}[email]
    ...    ${usuario}[password]
    ...    ${perfil}

    ${sql}=    Catenate    SEPARATOR=${SPACE}
    ...    INSERT OR REPLACE INTO usuarios_teste
    ...    (email, senha, perfil)
    ...    VALUES (?, ?, ?)

    Execute Sql String
    ...    ${sql}
    ...    parameters=${parametros}

Obter Usuário Administrador
    ${sql}=    Catenate    SEPARATOR=${SPACE}
    ...    SELECT email, senha
    ...    FROM usuarios_teste
    ...    WHERE perfil = 'admin'
    ...    ORDER BY id DESC
    ...    LIMIT 1

    ${linhas}=    Query    ${sql}

    Should Not Be Empty
    ...    ${linhas}
    ...    Nenhum administrador encontrado no banco de massa.

    &{usuario}=    Create Dictionary
    ...    email=${linhas}[0][0]
    ...    password=${linhas}[0][1]

    RETURN    ${usuario}
