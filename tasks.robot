*** Settings ***
Documentation       Playwright template.
Library             Collections
Library             RPA.Browser.Playwright
Library             libs.py

*** Settings ***
Variables         vars.py


*** Test Cases ***
Minimal task
    Starting a browser
    Start Typeform


*** Keywords ***
Wait And Get Question Title
    Wait For Elements State    [data-qa-focused="true"]
    Sleep    1s
    ${q_title}=    Evaluate JavaScript
    ...    [data-qa-focused="true"]
    ...    (element, arg) => element.querySelector('[data-qa^="block-title"]').innerText
    #...    (element, arg) => element.querySelector('label').innerText
    RETURN    ${q_title}

Get Quiz Data
    [Arguments]    ${q_title}
    &{q_data}=    get_quizz_data    ${q_title}    ${data_quizz}
    RETURN    ${q_data}

Fill Quizz
    [Arguments]    ${q_data}
    ${type}=    Get From Dictionary    ${q_data}    type
    ${response}=    Get From Dictionary    ${q_data}    response    
    IF    "${type}" == "input"
        Keyboard Input    type    ${response}
        Click OK
    ELSE
        ${resp_len}=    Get Length    ${response}
        FOR    ${element_select}    IN    @{response}
            Click    text=${element_select}
        END
        IF    (${resp_len} > 1)
            Click OK
        END
    END

Click OK
    Click    [data-qa-focused="true"] [data-qa="ok-button-visible deep-purple-ok-button-visible"]

Eval Qestion
    ${q_title}=    Wait And Get Question Title
    ${q_data}=    Get Quiz Data    ${q_title}
    Fill Quizz    ${q_data}

Starting a browser
    New Browser    chromium    headless=false
    Set Browser Timeout    5s
    ${context_desktop}=    New Context    viewport={'width': 1920, 'height': 1080}
    Switch Context    ${context_desktop}

Start Typeform
    ${data_len}=    Get Length    ${data_quizz}
    New Page    https://robocorp.typeform.com/to/ig9496MD
    Click    [data-qa="start-button"]
    FOR    ${element}    IN    @{data_quizz}
        Eval Qestion
    END
    