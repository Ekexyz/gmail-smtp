*** Settings ***
Library                     QForce
Library                     String
Library                     Collections
Library                     OperatingSystem
Library                     ../libraries/smtp.py
Test Teardown               Increment Counters
Suite Teardown              Suite End

*** Variables ***
${user}            your gmail address
${app_password}    your gmail app password
${sender}          no-reply.crt@gmail.com
${subject}         CRT test results
@{recipients}      list of emails
${pass}            0
${fail}            0

*** Keywords ***
Increment Counters
    IF  "${TEST STATUS}" == "PASS"
        ${pass}=  Evaluate  ${pass} + 1
    ELSE
        ${fail}=  Evaluate  ${fail} + 1
    END
    Set Suite Variable      ${pass}
    Set Suite Variable      ${fail}
    Log           Pass: ${pass} Fail: ${fail}

Suite End
    [Documentation]    Uses environent variables from CRT cloud container.
    ${body}=    Catenate    SEPARATOR=\n   Status of the Copado Robotic Testing suite ${SUITE NAME} is ${SUITE STATUS}.
    ...                        Passed (${pass}) / Failed (${fail}).
    ...                        Detailed report: https://eu-robotic.copado.com/robots/%{PROJECT_ID}/r/%{ROBOT_ID}/suite/%{JOB_ID}/runs/%{BUILD_ID}
    Send Email  CRT Suite Notification  ${body}  ${sender}  ${recipients}  ${user}  ${app_password}


*** Test Cases ***
Test1
    Log               running test 1
    Pass Execution    message=Test 1 passed

Test2
    Log              running test 2
    Fail             message=Test 2 failed

Test3
    Log              running test 3
    Pass Execution   message=Test 3 passed

