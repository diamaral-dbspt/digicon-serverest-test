language: pt-BR

*** Settings ***

Documentation       Teste usando datapool CSV

Library             SeleniumLibrary
Library             DataDriver        file=../../data/login_invalido.csv        encoding=utf_8        dialect=excel

Resource            ../../resources/configs/qa.resource
Resource            ../../resources/steps/login_steps.resource

Test Template       Login deve ser recusado

Test Setup          Open Browser    ${URL}    ${BROWSER}
Test TearDown       Close Browser

*** Test Cases ***
Realizar login incorreto com dados do datapool

*** Keywords ***
Login deve ser recusado
    [Arguments]    ${email}    ${senha}    ${alerta}

    Dado que a tela de login do sistema carregou
    Quando preencho corretamente meus dados de login    ${email}    ${senha}
    E submeto o formulário para entrar
    Então sistema deve apresentar mensagem de alerta    ${alerta}