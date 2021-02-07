# Test scripts written with reusability in mind e.g. the product search term is stored as a variable
# Use of page object model for easy test maintenance (webelement locators stored in seperate files, therefore many keywords can refer to a single locator)
# PageObjects folder contains the web element locators
# - Test Cases folder for high level gherkin style test / bdd statements
# - Resources folder for robot framework & selenium keywords
# - Results folder for output report viewable in any browser

*** Settings ***
Documentation    Hopin QA Test - UI
Library  SeleniumLibrary
Resource  ../../Resources/Keywords.robot
Resource  ../../Resources/Common.robot
Test Teardown   End TestCase

*** Test Cases ***
4: User can navigate from Customer List to Contact Details Screen
    [Tags]    User Interface Test
    Given I am on the Customer List Screen
    When I click on a customer name
    Then I see the Contacts Detail Screen for this customer

5: User can navigate from Contact Details Screen to Customer List Screen
    [Tags]    User Interface Test
    Given I am on the Customer Detail Screen
    When I click the Back to the list button
    Then I should see the Customer List Screen

6: Alert to be presented for Customer with no contact information
    [Tags]    User Interface Test
    Given I am on the Customer Detail Screen (missing info)
    When I select a customer that does not have contact information
    Then alert message "No contact info available" should be presented