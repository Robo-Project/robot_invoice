*** Settings ***
Library           OperatingSystem
Library           String
Library           Collections
Library           Selenium2Library

*** Variables ***
${INVOICEWEBSITE}       https://app.invoicesimple.com/invoices
${BROWSER}      Firefox
@{LINES}
${ROWS}
${NAME}
${PRODUCT}
${PRIZE}
${EMAIL}


*** Test Cases ***
Process Data File
    [Tags]    file-reading
    ${FILE_CONTENT}=   Get File    test.csv
    Log    File Content: ${FILE_CONTENT}
    Set Suite Variable      ${NUM}      3
    Log    ${NUM}
    @{LINES}=    Split to Lines and Remove Header   ${FILE_CONTENT}
    Log    ${LINES}
    Create invoices from csv file    @{LINES}


*** Keywords ***
Split to Lines and Remove Header
    [Arguments]    ${FILE_CONTENT}
    @{LINES}=    Split To Lines    ${FILE_CONTENT}
    Remove From List    ${LINES}    0
    [Return]    @{LINES}




Create invoices from csv file
    [Arguments]    @{LINES}
    Open Browser           url=${INVOICEWEBSITE}    browser=${BROWSER}
    Maximize Browser Window
    Click Element       //span[contains(text(),'Cancel')]
    #Execute javascript  document.body.style.zoom="70%"
    #Scroll Element Into View    //div[contains(text(),'Close Invoice')]
    #Execute JavaScript    window.scrollTo(0, 100)
    Click Button       Close invoice
    #Set Global Variable  @{LINES}
           :FOR    ${LINE}    IN     @{LINES}
                Click Element       //span[contains(text(),'New Invoice')]
                Log to console     Value is ${LINE}
                @{ROWS}=  Split String    ${LINE}     , 
                Log to console          rivit @{ROWS} 
                ${NAME}=   Get From List   ${ROWS}  0   
                Input Text              id=invoice-company-name        Robot
                Input Text              id=invoice-client-name        ${NAME}
                ${PRODUCT}=   Get From List    ${ROWS}     1   
                #Input Text              id=invoice-item-code        ${PRODUCT}
                #${PRIZE}=   Get From List   ${ROWS}     2   
                #Clear Element Text     class:item-row-rate
                #Input Text              class:react-numeric-input        ${PRIZE}
                #${AMOUNT} Get From List   ${ROWS} 3   
                #Log ${AMOUNT}
                #Input Text              //td[@class='item-row-quantity'        ${AMOUNT}
                ${EMAIL}=  Get From List   ${ROWS}     4   
                Input Text              id=invoice-client-email        ${EMAIL}
                Click Button       Close invoice
           END
    Close Browser