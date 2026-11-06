language: pt-Br

*** Settings ***

Documentation        Teste de Login - Consulta de Usuário DB

Library              SeleniumLibrary

Resource             ../../resources/configs/qa.resource
Resource             ../../resources/configs/db.resource
Resource             ../../resources/steps/login_steps.resource

Suite Setup         Preparar base de dados
Suite Teardown      Disconnect From Database

Test Setup          Open Browser    ${URL}    ${BROWSER}
Test Teardown       Close Browser

Test Tags           login    db

*** Test Cases ***
Realizar login com usuário cadastrado na base de dados
    Login com usuário da base de dados

*** Keywords ***
Login com usuário da base de dados
    ${usuario}=    Obter Usuário Administrador

    Dado que a tela de login do sistema carregou
    Quando preencho corretamente meus dados de login        ${usuario}[email]    ${usuario}[password]
    E submeto o formulário para entrar
    Então devo visualizar tela de administrador
    E devo visualizar as opções restritas