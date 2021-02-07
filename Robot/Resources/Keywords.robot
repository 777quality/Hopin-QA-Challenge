*** Settings ***
Library  SeleniumLibrary
Variables  ../PageObjects/ContactDetailsScreenLocators.py
Variables  ../PageObjects/CustomerListScreenLocators.py
Variables  ../PageObjects/WelcomeScreenLocators.py

*** Variables ***
@{list_of_customers}    ${first_customer}   ${second_customer}  ${third_customer}   ${fourth_customer}  ${fifth_customer}   ${sixth_customer}
${URL}          http://localhost:3000/
${BROWSER}      chrome
${username}     Mahatma Gandhi UI Tests
${customer_list_screen_text}    Click on each of them to view their contact details.
${FIRST_CUSTOMER_NAME}=  Get Text    ${first_customer}
${CUSTOMER_NAME_VALIDATION}=     Get Text    ${first_customer}
${CUSTOMER_NAME}

*** Keywords ***
I am on the Customer List Screen
         ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    no-sandbox
    Call Method    ${chrome_options}   add_argument    disable-dev-shm-usage
    ${options}=     Call Method     ${chrome_options}    to_capabilities
        Open Browser          ${URL}    ${BROWSER}  desired_capabilities=${options}
    Maximize Browser Window
    Wait Until Page Contains Element    ${submit_button}
    Input Text  ${username_textbox}     ${username}
    Click Button    ${submit_button}
    Page Should Contain    ${customer_list_screen_text}
    #VALIDATION checks user is on Customer List Screen

I click on a customer name
    #the following is a LOOP in which the first customer -> sixth customer Contacts Detail Screen is displayed
    FOR  ${customer}     IN      @{list_of_customers}
         ${CUSTOMER_NAME}=    Get Text    ${customer}
    Set Suite Variable  ${CUSTOMER_NAME}
    log     ${CUSTOMER_NAME}
        click element   ${customer}
    I see the Contacts Detail Screen for this customer
    END

I see the Contacts Detail Screen for this customer
    Page Should Contain Button      ${Back_to_list_button}
    Wait Until Page Contains Element    ${Back_to_list_button}
    Log     ${CUSTOMER_NAME}
    #VALIDATION - this checks the customer name on the customer list screen matches the one on the contact details screen
    Element Should Contain      ${Contact_Details_Name}     ${CUSTOMER_NAME}
    Click element   ${Back_to_list_button}

I am on the Customer Detail Screen
    I am on the Customer List Screen
    I click on a customer name
    #this keyword makes use of existing keywords to fulfill a test case of different purpose, I try to ensure reusability of automation code where possible.

I click the Back to the list button

I should see the Customer List Screen

I am on the Customer Detail Screen (missing info)
    I am on the Customer List Screen

I select a customer that does not have contact information
    #selects customer with known issue of no data for Contact Information
    click element   ${fourth_customer}

alert message "No contact info available" should be presented
    #no name and e-mail contact information on contact details screen
    #for the purpose of this test, it is know that the customer named "United Brands" ${fourth_customer} does not have contact information on the API response, therefore I am treating this as test data for this scenario
   Wait Until Page Contains Element    ${Back_to_list_button}
    #CLARIFICATION - required clarification on the message when no contact information is available
    Page should contain     No contact info available
    #VALIDATION - checks that the page contains the text "No contact info available"
    Alert Should Be Present     No contact info available    action=ACCEPT
    #VALIDATION - checks that the page contains an Alert with the text "No contact info available"