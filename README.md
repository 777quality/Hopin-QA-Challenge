# Hopin QA Challenge
# Table of Contents
1. [Task 1 - Clone Repo](https://github.com/DaleSDET/Hopin-QA-Challenge/blob/main/README.md#task-1---clone-repo)
2. [Task 2 - Create a test plan and run it manually](https://github.com/DaleSDET/Hopin-QA-Challenge/blob/main/README.md#task-2---create-a-test-plan-and-run-it-manually)
3. [Task 3 - Create an automated API level test scenario](#third-example)
4. [Task 4 - Create an automated UI level test scenario](#fourth-examplehttpwwwfourthexamplecom)
5. [How to install / run the test suite]()

## Task 1 - Clone Repo

[Test Env Screenshot](https://github.com/DaleSDET/Hopin-QA-Challenge/blob/main/Screenshot%202021-01-27%20125703.jpg)

## Task 2 - Create a test plan and run it manually

NB: I have taken note of the requirement for a "test plan that will **minimally** contain the steps that have to be taken" in respect to this, the documented tests below are not as extensively detailed as they may have been.

Our approach is a blend of exploratory testing with test automation for the UI user journeys and API's.

### In Scope

| Module   | Description |
| ------------- | ------------- |
| Welcome Screen  | The Welcome Screen presents the user to a form where he/she can be identified. The form consists of, Instructions text: "Please provide your name:", A text field where the user will input his/her name, and A Submit button.|
| Customer List Screen | This screen presents the list of all registered customers. For each customer, the following info is shown: <BR>1. Name <BR><BR> 2. Number of Employees <BR><BR> 3. Size: if number of Employees is less than or equal 100, size is Small; if greater than 10 and less than or equal to 1000, Medium; otherwise, Large <BR><BR> When the user clicks on a customer name, the Contacts Detail Screen is shown.  |
| Contact Details Screen | This screen shows the customers detailed info (Name, # of Employees, and Size) and also the name and e-mail of the person in the company to be contacted. |
| API | Content Cell  |

### Out of Scope

### Test Environment
[Test Environment Setup Instructions](https://github.com/smcostareisHopin/Hopin-Exam-QE/blob/main/TestEnvironment.md)

http://localhost:3000/

___

### Test Cases
####  Welcome Screen
##### 1: Submit a valid name
| ID#  | BDD | Notes | Test Result |
| :------------- | :------------- | :------------- | :------------- |
| 1   | Given I am on the welcome screen <br/> When I provide my name <br/> And I submit my name <br/> Then I can see the Customer List Screen |  | :heavy_check_mark: |

##### 2: Submit a blank name
| ID#  | BDD | Notes | Test Result |
| :------------- | :------------- | :------------- | :------------- |
| 2  | Given I am on the welcome screen <br/> When I leave the name field blank <br/> And I submit my name <br/> Then I can see an alert message | Alert message should read "Please provide your name."  | :heavy_check_mark: |

####  Customer List Screen
##### 3: Validate presence of all customers on Customer List Screen
| ID#  | BDD | Notes | Test Result |
| :------------- | :------------- | :------------- | :------------- |
| 3   | Given I am on the Customer List Screen <br/> Then I can see all registered customers | Validations on presence of Name, # of Employees, Size: if # of Employees for all customers | :heavy_check_mark: |

##### 4: User can navigate from Customer List to Contact Details Screen
| ID#  | BDD | Notes | Test Result |
| :------------- | :------------- | :------------- | :------------- |
| 4   | Given I am on the Customer List Screen <br/> When click on a customer name <br/> Then the Contacts Detail Screen for this customer | Test fails upon selecting Name: United Brands - "TypeError: Cannot read property 'name' of undefined" | :x: |

####  Contact Details Screen
##### 5: User can navigate from Contact Details Screen to Customer List Screen 
| ID#  | BDD | Notes | Test Result |
| :------------- | :------------- | :------------- | :------------- |
| 5   | Given I am on the Customer Detail Screen <br/> When I click the Back to the list button <br/> Then I should see the Customer List Screen | Test fails for the user named United Brands, as back to the list button is not displayed, due to error seen in test 4. | :x: |

##### 6: Alert to be presented for Customer with no contact information
| ID#  | BDD | Notes | Test Result |
| :------------- | :------------- | :------------- | :------------- |
| 6   | Given I am on the Customer Detail Screen <br/> When a customer does not have contact information <br/> Then message "No contact info available" should be presented | Test Failed, unable to verify from the UI, as per error seen in Test 4. All other existing data contains user contact information, thus no Alert message seen. | :x: |

####  API
##### 7: validate the size object in the response
| ID#  | BDD | Notes | Test Result |
| :------------- | :------------- | :------------- | :------------- |
| 7  | Given I am on the Customer List Screen <br/> And # of Employees is {EmployeeCount} <br/> Then Text Size = {TextSize} | {EmployeeCount}  {TextSize} <br/> <= 100      Small <br/>  >100 and <= 1000   Medium <br/>  >= 1001      Big | :heavy_check_mark: |

##### 8: validate the size object in the response
| ID#  | BDD | Notes | Test Result |
| :------------- | :------------- | :------------- | :------------- |
| 8  | Given I am on the Customer List Screen <br/> And # of Employees is {EmployeeCount} <br/> Then Text Size = {TextSize} | {EmployeeCount}  {TextSize} <br/> <= 100      Small <br/>  >100 and <= 1000   Medium <br/>  >= 1001      Big | :heavy_check_mark: |

## Claifications / Assumptions

Contacts Detail Screen - "the message No contact info available should be presented." it is not made clear how this message should be presented exactly, is this a popup message, an overlay or a text message within an onscreen element? will the customer information still be displayed, despite the lack of contact information?

"Create a test plan that will *minimally* contain the steps that have to be taken and their expected results;" the term, minimally contain the steps that have to be taken, can be interpreted in multiple ways. One way could be that it is referring to the test steps, and to minimally outline these. Another way, and the way that it has been applied here is that it is referring to the fact that an extensive test plan is not required, rather one that validates the requirements in the requirements document only, and nothing else.

There are multiple typos throughout the task description.

"Size: if # of Employees is less than or equal 100, size is Small; if greater then 10 and less then or equal 1000, Medium; otherwise, Big"
 I need to question this, and find out what Size is referring to, it would be assumed the text size. However, even in this case, Big, Medium and Small need to be defined.
 
"When a customer doesn't have contact info, the message No contact info available should be presented." How is such an alert to be provided? where? Should the customer contact detail screen still load?

The requirements contain two conflicting statements:

* Size: if # of Employees is less than or equal 100, size is Small; if greater then 10 and less then or equal 1000, Medium; otherwise, Big
* customer size is: Small, when # of employees is <= 10; Medium when it is <= 1000; Big otherwise.

I have assumed that this is a typo, and the correct requirement is Size: if # of Employees is less than or equal 100, size is Small; if greater then 100 and less then or equal 1000, Medium; otherwise, Big

## How to install / run the test suite

the following instructions are written for Windows users.

Install and then Open Git Bash - https://gitforwindows.org/

Go to the current directory where you want the cloned directory to be added.

Clone the respository by your preferred method, or type:

$ git clone https://github.com/777quality/Hopin-QA-Challenge.git

Press Enter

Start the application under test as detailed in [Test Environment Setup Instructions](https://github.com/smcostareisHopin/Hopin-Exam-QE/blob/main/TestEnvironment.md)


