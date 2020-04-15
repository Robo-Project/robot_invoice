*** Settings ***
Library           OperatingSystem
Library           String
Library           Collections
Library           Selenium2Library

*** Variables ***
${INVOICEWEBSITE}       https://app.freeinvoicebuilder.com/
${BROWSER}              Chrome
@{LINES}
${ROWS}
${NAME}
${PRODUCT}
${PRIZE}
${EMAIL}
${USERNAME}         
${PASSWORD}         


*** Test Cases ***
Process Data File
    [Tags]    file-reading
    ${FILE_CONTENT}=     Get File    test.csv
    Log                  File Content: ${FILE_CONTENT}
    @{LINES}=            Split to Lines and Remove Header   ${FILE_CONTENT}
    Log    ${LINES}
    Logging in to site
    Create invoices from csv file    @{LINES}


*** Keywords ***
Split to Lines and Remove Header
    [Arguments]         ${FILE_CONTENT}
    @{LINES}=           Split To Lines    ${FILE_CONTENT}
    Remove From List    ${LINES}           0
    [Return]     @{LINES}


Logging in to site 
    Open Browser           url=${INVOICEWEBSITE}    browser=${BROWSER}     
    Maximize Browser Window
    Wait Until Element Is Visible       id=username
    Input Text              id=username        
    Input Text              id=password        
    Click Button            login

Create invoices from csv file
    [Arguments]    @{LINES}
           :FOR    ${LINE}    IN     @{LINES}
                Wait Until Element Is Visible       //*[contains(text(),'New Invoice')]
                Click Element       //*[contains(text(),'New Invoice')]
                Log to console     Value is ${LINE}
                @{ROWS}=  Split String    ${LINE}     , 
                Log to console          rivit @{ROWS} 
                #Wait Until Element Is Visible        //*[@id="panel-two"]/div[3]/div[1]/div[2]/div[1]/div/div[2]/div[1]/div[3]/div[2]/div[2]
                #Click Element       asiakkaan tietoihin klikkaus
                
                #${NAME}=   Get From List   ${ROWS}  0   
                #Input Text              id=invoice-client-name        ${NAME}
                #${EMAIL}=  Get From List   ${ROWS}     7   
                #Input Text              id=invoice-client-email        ${EMAIL}
                Wait Until Element Is Visible       //*[contains(text(),'Add New Invoice Item')]
                Click Element       //*[contains(text(),'Add New Invoice Item')]
                ${PRODUCT}=   Get From List    ${ROWS}       1   
                Input Text    name=item        ${PRODUCT}
                ${PRIZE}=     Get From List    ${ROWS}       2   
                Input Text    name=rate        ${PRIZE}
                ${AMOUNT}     Get From List    ${ROWS}       3   
                Input Text    name=quantity    ${AMOUNT}

                Wait Until Element Is Visible  //*[contains(text(),'Add New Invoice Item')]
                Click Element                  //*[contains(text(),'Add New Invoice Item')]
                ${PRODUCT}=   Get From List    ${ROWS}       4   
                Input Text    name=item        ${PRODUCT}
                ${PRIZE}=     Get From List    ${ROWS}       5   
                Input Text    name=rate        ${PRIZE}
                ${AMOUNT}     Get From List    ${ROWS}       6   
                Input Text    name=quantity    ${AMOUNT}
                Click Element                  //*[contains(text(),'Invoices')]
           END
    Close Browser