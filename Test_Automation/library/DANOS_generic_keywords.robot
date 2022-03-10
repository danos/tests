# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

#Generic Keyword File for interaction with DANOS
*** Settings ***
Library           SSHLibrary
Library           String
Library           Collections

*** Variables ***
${user}      vyatta
${pa}        vyatta

*** Keywords ***
LoginToRouter
    [Arguments]    ${arg1}
    Open Connection   ${arg1}    prompt=$    alias=${arg1}    timeout=20
    Login   ${user}    ${pa}
    Write    set terminal length 0
    Read Until    $

Logout
    Close All Connections

ShowCommand
    [Arguments]    ${arg1}    ${arg2}
    Switch Connection    ${arg1}
    Write    ${arg2}
    ${output}    Read Until    $
    [Return]    ${output}

SetCommand
    [Arguments]    ${arg1}    ${arg2}
    Switch Connection    ${arg1}
    Write    configure
    Read Until    \#
    FOR  ${line}  IN    @{arg2}
        ${cmd}    Catenate    set    ${line}
        Log    ${cmd}
        Write    ${cmd}
        Read Until    \#
    END
    Write    commit
    Read Until    \#
    Write    exit
    Read Until    $

DeleteCommand
    [Arguments]    ${arg1}    ${arg2}
    Switch Connection    ${arg1}
    Write    configure
    Read Until    \#
    FOR  ${line}  IN    @{arg2}
        ${cmd}    Catenate    delete    ${line}
        Log    ${cmd}
        Write    ${cmd}
        Read Until    \#
    END
    Write    commit
    Read Until    \#
    Write    exit
    Read Until    $

SetWrongCommand
    [Arguments]    ${arg1}    ${arg2}
    Switch Connection    ${arg1}
    Write    configure
    Read Until    \#
    FOR  ${line}  IN    Get From List    @{arg2}
        ${cmd}    Catenate    set    ${line}
        Log    ${cmd}
        Write    ${cmd}
        ${output}    Read Until    \#
    END
    Write    exit
    Read Until    $
    [Return]    ${output}