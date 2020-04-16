*** Settings ***
Library           OperatingSystem
Library           String
Library           Collections
Library           Selenium2Library

*** Variables ***
${INVOICEWEBSITE}       https://app.freeinvoicebuilder.com/
${BROWSER}              Chrome
${INVOICECOUNT}
${USERNAME}             change_login_email_here 
${PASSWORD}             change_login_password_here


*** Test Cases ***
Remove Invoices
    Logging in to site
    Delete invoices


*** Keywords ***
Logging in to site 
    Open Browser                    url=${INVOICEWEBSITE}    browser=${BROWSER}     
    Maximize Browser Window
    Wait Until Element Is Visible   id=username
    Input Text                      id=username         ${USERNAME}       
    Input Text                      id=password         ${PASSWORD}
    Click Button                    login

Delete invoices

    Wait Until Element Is Visible       class=draft
    ${INVOICECOUNT}=                    Get Element Count       class=draft
 
    FOR    ${INDEX}    IN RANGE    ${INVOICECOUNT}
        Wait Until Element Is Visible       class=draft
        Click Element                       class=draft

        Wait Until Element Is Visible       class=main-action
        Click Element                       class=main-action

        Wait Until Element Is Visible       class=ti-settings
        Click Element                       class=ti-settings

        Wait Until Element Is Visible       class=delete-invoice-button
        Click Element                       class=delete-invoice-button

        Wait Until Element Is Visible       class=red
        Click Element                       class=red
    END

    Close Browser
