*** Settings ***
Library  SeleniumLibrary
Resource  setup_teardown.resource
Suite Setup  Prepare the test suite
Test Setup  Prepare the test case
Test Teardown  Clean up the test case
Suite Teardown  Clean up the test suite

*** Variables ***
&{CATEGORIES}
...  private=Personnel
...  professional=Professionnel

*** Test Cases ***
I can add a todo
  Page Should Contain Element  data-id:input.text.description
  Submit a todo  Adopter de bonnes pratiques de test
  A new todo should be created  1  Adopter de bonnes pratiques de test

I can complete one of several todos
  Submit a todo  Adopter de bonnes pratiques de test
  Submit a todo  Comprendre le Keyword-Driven Testing
  Submit a todo  Automatiser des cas de test avec Robot Framework
  A new todo should be created  1  Adopter de bonnes pratiques de test
  A new todo should be created  2  Comprendre le Keyword-Driven Testing
  A new todo should be created  3  Automatiser des cas de test avec Robot Framework
  Complete a todo  2
  The todo should be completed  2
  The todo should be uncompleted  1
  The todo should be uncompleted  3

I can remove a todo
  Submit a todo  Choisir le bon type de framework de test
  Remove a todo  1
  The todo should be deleted  1

I can categorize some todos
  Submit a todo  Choisir un livre intéressant
  The todo should not be categorized  1
  Submit a todo  Marcher et faire du vélo avec mon chien  ${CATEGORIES.private}
  The todo 2 should be private
  Submit a todo  Faire un câlin avec mon chat
  The todo 3 should be private
  Submit a todo  Automatiser un cas de test de plus  ${CATEGORIES.professional}
  The todo 4 should be professional

*** Keywords ***
Submit a todo
  [Arguments]  ${description}  ${category}=${None}
  Run Keyword Unless  '${category}' == '${None}'
  ...  Select From List By Value  data-id:select.category  ${category}
  Input Text  data-id:input.text.description  ${description}
  Submit Form

A new todo should be created
  [Arguments]  ${number}  ${description}
  Element Should Contain  todo:${number}  ${description}
  Checkbox Should Not Be Selected  data-id:input.checkbox.done-${number}

Complete a todo
  [Arguments]  ${number}
  Select Checkbox  data-id:input.checkbox.done-${number}

The todo should be completed
  [Arguments]  ${number}
  Checkbox Should Be Selected  data-id:input.checkbox.done-${number}

The todo should be uncompleted
  [Arguments]  ${number}
  Checkbox Should Not Be Selected  data-id:input.checkbox.done-${number}

Remove a todo
  [Arguments]  ${number}
  Page Should Contain Button  data-id:button.remove_todo-${number}
  Click Button  data-id:button.remove_todo-${number}

The todo should be deleted
  [Arguments]  ${number}
  Page Should Not Contain Element  todo:${number}

The todo should not be categorized
  [Arguments]  ${number}
  Page Should Not Contain Element  data-id:category-${number}

The todo ${number} should be ${category}
  Element Text Should Be  data-id:category-${number}  ${CATEGORIES.${category}}
