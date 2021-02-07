*** Keywords ***
Start TestCase
    Maximize Browser Window

End TestCase
    Close Browser

Verify Page Title
    [Arguments]  ${Page_Title}
    Title Should be  ${Page_Title}

Capture Screenshot Page
    [Arguments]  ${file_name}
    Capture page Screenshot    ${file_name}