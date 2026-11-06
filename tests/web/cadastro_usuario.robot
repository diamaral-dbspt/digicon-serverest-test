language: pt-BR

*** Settings ***
Documentation       Testes automatizados - Cadastro de usuário

Resource            ../../resources/configs/qa.resource
Resource            ../../resources/steps/cadastrar_steps.resource
Resource            ../../resources/configs/dados.resource
Resource            ../../resources/configs/db.resource

Suite Setup         Preparar base de dados
Suite Teardown      Disconnect From Database

Test Setup          Open Browser    ${URL}    ${BROWSER}
Test Teardown       Close Browser

Test Tags           login    gerador

*** Test Cases ***
Realizar login com dados de usuário gerados automaticamente        
    Login com usuário gerado

*** Keywords ***
Login com usuário gerado
    ${usuario}=    Gerar Usuário

    Dado que acessei o sistema ServeRest
    E acessei a página de cadastro
    Quando preencho o formulário com meus dados        ${usuario}[nome]         ${usuario}[email]        ${usuario}[password]
    E marco o campo "administrador" se for o caso      ${true}
    E submeto os dados
    Então devo ver a mensagem de sucesso na tela       Cadastro realizado com sucesso

    Registrar Usuário No Banco    ${usuario}    admin