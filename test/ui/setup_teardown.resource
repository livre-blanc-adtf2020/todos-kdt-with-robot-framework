*** Settings ***
Library  SeleniumLibrary

*** Keywords ***
Prepare the test suite
  Open Browser  url=http://localhost:9090  browser=chrome
  Set Window Size  width=600  height=300  inner=true
  Set Selenium Timeout  10 seconds
  ${selenium_speed} =  Get Variable Value  ${SPEED}  0
  Set Selenium Speed  ${selenium speed} seconds
  Add Location Strategy  strategy_name=data-id  strategy_keyword=test id locator strategy
  Add Location Strategy  strategy_name=todo  strategy_keyword=todo locator strategy

Test id locator strategy
  [Arguments]  ${browser}  ${locator}  ${tag}  ${constraints}
  ${element}=  Execute Javascript  return window.document.querySelector('[data-id="${locator}"]');
  [Return]  ${element}

Todo locator strategy
  [Arguments]  ${browser}  ${locator}  ${tag}  ${constraints}
  ${element}=  Execute Javascript  return window.document.querySelector('ul > li[data-id="todo-${locator}"]');
  [Return]  ${element}

Prepare the test case
  Wait Until Page Contains Element  id:heading
  Title Should Be  Tout Doux

Clean up the test case
  Reload Page

Clean up the test suite
  Close All Browsers
