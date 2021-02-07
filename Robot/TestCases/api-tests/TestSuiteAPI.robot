*** Settings ***
Documentation    Hopin QA Test - API
Library     RequestsLibrary
Library     Collections
Library     JSONLibrary
Library     OperatingSystem
Library     SeleniumLibrary
Library     BuiltIn
Library	    JsonValidator

*** Variables ***
${base_url}     http://localhost:3001/
${body}=  builtin.convert to string  {"name":"Mahatma Gandhi API"}
${header}=  create dictionary   Content-Type=application/json

*** Test Cases ***
API 1: POST Response - validate status 200
    [Tags]    API Test
    create post request
    log to console    ${response.status_code}
    log to console    ${response.content}
    log to console    ${response.headers}
    ${status_code}=   convert to string  ${response.status_code}
    #VALIDATION - Expected: Status: 200 OK
    should be equal    ${status_code}   200

API 2: POST Response - validate name and response is as previously seen
    [Tags]    API Test
    create post request
    #VALIDATION verify name object in json response
    ${user_name}=    get value from json    ${json_object}   $.name
    log to console    ${user_name[0]}
    should be equal    ${user_name[0]}  Mahatma Gandhi API
    #VALIDATION - verify entire message response is as expected (as previously seen)
    ${res_body}=    convert to string    ${response.content}
    should contain  ${res_body}  {"name":"Mahatma Gandhi API","timestamp":"Sun Feb 07 2021","customers":[{"id":1,"name":"Americas Inc.","employees":10,"contactInfo":{"name":"John Smith","email":"jsmith@americasinc.com"},"size":"Small"},{"id":2,"name":"Caribian Airlnis","employees":1000,"contactInfo":{"name":"Jose Martinez","email":"martines@cair.com"},"size":"Big"},{"id":3,"name":"MacroSoft","employees":540,"contactInfo":{"name":"Bill Paxton","email":"bp@ms.com"},"size":"Medium"},{"id":4,"name":"United Brands","employees":20,"size":"Small"},{"id":5,"name":"Bananas Corp","employees":10000,"contactInfo":{"name":"Xavier Hernandez","email":"xavier@bananas.com"},"size":"Big"},{"id":6,"name":"XPTO.com","employees":102,"contactInfo":{"name":"Daniel Zuck","email":"zuckh@xpto.com"},"size":"Medium"}]}

API 3: POST Response - if no contact info then no contactInfo attribute
    [Tags]    API Test
    Create post request
    ${customer_without_contactdetails}=    get value from json    ${json_object}   $.customers[3]
    log to console    ${customer_without_contactdetails}
    #VALIDATION - this test uses a customer which is known not to have contact email and name
    should not contain    ${customer_without_contactdetails}    contactInfo

API 4: POST Response - validate SIZE attribute logic
    [Tags]    API Test
    # it is KNOWN that this test will fail, as there is an error with the response for Caribian Airlnis customer
    create post request
    # Capture ALL employee count values from json response and store in list variable
    @{employee_count_list}=     get value from json    ${json_object}   $.customers[0:].employees
    # Capture ALL business size values from json response and store in list variable
    @{business_size_list}=    get value from json    ${json_object}   $.customers[0:].size
    # VALIDATION - Where {#Employee_Count} is #<= 100 then Small, #>100 and <= 1000 then Medium, else #>= 1001 then Big
    # This will loop this logic around all the values returned in customers employees and size
    FOR     ${employee_count}   ${business_size}    IN ZIP      ${employee_count_list}      ${business_size_list}
    log to console   Employee Count: ${employee_count}
    log to console   Business Size: ${business_size}
    run keyword if    ${employee_count} <= 100 and "${business_size}" == "Small"      TESTPASS
    ...    ELSE IF    ${employee_count} > 100 <= 1000 and "${business_size}" == "Medium"   TESTPASS
    ...    ELSE IF    ${employee_count} >= 1001 and "${business_size}" == "Big"    TESTPASS
    ...    ELSE     Run Keyword And Continue On Failure     TESTFAILED
    END
    # If the test failes on particular data, it will continue to validate the rest of the data items
    # It is possible to further enhance this by printing what would be expected, however this can be easily seen in the test report

API 5: POST Response - Validate response against JSON Schema
    [Tags]    API Test
    create post request
    # Convert response string to JSON object
    ${json_object}=     to json    ${response.content}
    log to console     ${json_object}
    ${json_string}=    json to string    ${json_object}
    Pretty Print Json   ${json_string}
    Validate Jsonschema From File   ${json_object}      ../../Resources/JSONSchema/POSTresponseSchema.json

*** Keywords ***
Create post request
    # Create POST request with body and header, JSON format, declare response as Global variable
    create session  HopinAPI   ${base_url}
    ${body}=  builtin.convert to string  {"name":"Mahatma Gandhi API"}
    ${header}=  create dictionary   Content-Type=application/json
    ${response}=    post request  HopinAPI    uri=    data=${body}    headers=${header}
    set global variable         ${response}
    ${json_object}=     to json    ${response.content}
    set global variable        ${json_object}

TESTPASS
    # prints a message to console
    log to console    Test PASSED: Business Size attribute is as per expected logic

TESTFAILED
    # prints a message to console
    log to console    Test FAILED: Business Size attribute is NOT as per expected logic
    # fails the test
    fail    Test FAILED: Business Size attribute is NOT as per expected logic