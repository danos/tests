# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
*** Settings ***
Library           SSHLibrary
Library           String
Library           Collections

Resource          ../testdata/OSPF_DANOS_testdata2.robot
Resource          ../library/DANOS_generic_keywords.robot

*** Variables ***

*** Keywords ***
Access 2 devices
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Access check to the device ${vm}
        LoginToRouter    ${vm}
    END

Access 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Access check to the device ${vm}
        LoginToRouter    ${vm}
    END

Access check and enable vymgmt support in 2 devices
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Access check and enable vymgmt support on ${vm}
        ShowCommand    ${vm}    ${access}[0]
        ${output}    ShowCommand    ${vm}    ${access}[1]
        Log    ${output}
        Should Contain    ${output}    danos
    END

Access check and enable vymgmt support in 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Access check and enable vymgmt support on ${vm}
        ShowCommand    ${vm}    ${access}[0]
        ${output}    ShowCommand    ${vm}    ${access}[1]
        Log    ${output}
        Should Contain    ${output}    danos
    END

Clear configurations on the topology in 2 devices
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Delete configurations on ${vm}
        DeleteCommand    ${vm}    ${delete_config}
    END

Clear configurations on the topology in 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Delete configurations on ${vm}
        DeleteCommand    ${vm}    ${delete_config}
    END

Clear Protocol configurations on the topology in 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Delete configurations on ${vm}
        DeleteCommand    ${vm}    ${delete_protocol}
    END

Configure interfaces in 2 devices
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Configure interfaces on ${vm}
        ${config}    Set Variable If   '${vm}' == '${R1}'  ${R1_interface_config}
                     ...               '${vm}' == '${R2}'  ${R2_interface_config}
        SetCommand    ${vm}    ${config}
    END

Configure interfaces with different MTU in 2 devices
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Configure interfaces on ${vm}
        ${config}    Set Variable If   '${vm}' == '${R1}'  ${R1_interface_config_diff_MTU}
                     ...               '${vm}' == '${R2}'  ${R2_interface_config_diff_MTU}
        SetCommand    ${vm}    ${config}
    END

Configure interfaces in 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Configure interfaces on ${vm}
        ${config}    Set Variable If   '${vm}' == '${R1}'  ${R1_interface_config_3}
                     ...               '${vm}' == '${R2}'  ${R2_interface_config_3}
                     ...               '${vm}' == '${R3}'  ${R3_interface_config_3}
        SetCommand    ${vm}    ${config}
    END

Configure routing protocol in 2 devices
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Configure OSPF on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config}
        SetCommand    ${vm}    ${protocol}
    END

Configure routing protocol with same router-id in 2 devices
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Configure OSPF on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config_r1_routerid}
        SetCommand    ${vm}    ${protocol}
    END

Configure routing protocol in 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Configure OSPF on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config_3}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config_3}
                       ...               '${vm}' == '${R3}'  ${R3_protocol_config_3}
        SetCommand    ${vm}    ${protocol}
    END

Configure routing protocol with redistribute in 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Configure OSPF on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config_3}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config_3}
                       ...               '${vm}' == '${R3}'  ${R3_protocol_config_3_wo_lb}
        SetCommand    ${vm}    ${protocol}
    END

Configure routing protocol without Router-id in 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Configure OSPF on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config_3_wo_router-id}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config_3_wo_router-id}
                       ...               '${vm}' == '${R3}'  ${R3_protocol_config_3_wo_router-id}
        SetCommand    ${vm}    ${protocol}
    END

Configure routing protocol in R1
    Log    Configure OSPF on ${R1}
    SetCommand    ${R1}     ${R1_protocol_config}

Configure routing protocol in R2
    Log    Configure OSPF on ${R2}
    SetCommand    ${R2}     ${R2_protocol_config}

Configure routing protocol with wrong area and Validate the error in R1
    Log    Configure OSPF on ${R1}
    ${output}    SetWrongCommand    ${R1}     ${R1_protocol_config_wrong_area}
    Log    ${output}
    Should Contain    ${output}   Set failed

Show Interfaces in 2 devices
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Show Interfaces on ${vm}
        ${output}    ShowCommand    ${vm}    show interfaces
        Log    ${output}
    END

Show Interfaces in 3 devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Show Interfaces on ${vm}
        ${output}    ShowCommand    ${vm}    show interfaces
        Log    ${output}
    END

Reset OSPF protocol on R1
    Log    Reset OSPF protocol on R1
    ShowCommand    ${R1}     ${reset_proto_ospf}

Reset OSPF protocol on R2
    Log    Reset OSPF protocol on R2
    ShowCommand    ${R2}     ${reset_proto_ospf}

Reset OSPF protocol on R3
    Log    Reset OSPF protocol on R3
    ShowCommand    ${R3}     ${reset_proto_ospf}

Validate OSPF neighbor status - Full on R1
    Log    Validate OSPF neighbor status on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}   Full

Validate OSPF neighbor status - Full on R2
    Log    Validate OSPF neighbor status on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Full

Validate OSPF neighbor status - Full on R3
    Log    Validate OSPF neighbor status on R3
    ${output}    ShowCommand    ${R3}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Full

Validate OSPF neighbor status - 2-Way on R1
    Log    Validate OSPF neighbor status on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    2-Way

Validate OSPF neighbor status - 2-Way on R2
    Log    Validate OSPF neighbor status on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    2-Way

Validate OSPF neighbor status - Init on R1
    Log    Validate OSPF neighbor status on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Init

Validate OSPF neighbor status - Init on R2
    Log    Validate OSPF neighbor status on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Init

Validate OSPF neighbor status - ExStart on R1
    Log    Validate OSPF neighbor status on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    ExStart

Validate OSPF neighbor status - ExStart on R2
    Log    Validate OSPF neighbor status on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    ExStart

Validate OSPF neighbor status - Exchange on R1
    Log    Validate OSPF neighbor status on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Exchange

Validate OSPF neighbor status - Exchange on R2
    Log    Validate OSPF neighbor status on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Exchange

Validate OSPF neighbor election - DR on R1
    Log    Validate OSPF neighbor election - DR on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Full/DR

Validate OSPF neighbor election - Backup on R1
    Log    Validate OSPF neighbor election - Backup on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Full/Backup

Validate OSPF neighbor election - DR on R2
    Log    Validate OSPF neighbor election - DR on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Full/DR

Validate OSPF neighbor election - Backup on R2
    Log    Validate OSPF neighbor election - Backup on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Full/Backup

Validate OSPF neighbor election - DR on R2 with highest priority
    Log    Validate OSPF neighbor election - DR on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    7 Full/DR

Validate OSPF neighbor election - DR on R3
    Log    Validate OSPF neighbor election - DR on R3
    ${output}    ShowCommand    ${R3}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Full/DR

Validate OSPF neighbor election - Backup on R3
    Log    Validate OSPF neighbor election - Backup on R3
    ${output}    ShowCommand    ${R3}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    Full/Backup

Validate OSPF neighbor election - DROther on R3
    Log    Validate OSPF neighbor election - DR on R3
    ${output}    ShowCommand    ${R3}    ${show_ospf_neighbor}
    Log    ${output}
    Should Contain    ${output}    DROther

Modify OSPF High Priority on R1
    Log    Reset OSPF protocol on R1
    SetCommand    ${R1}     ${set_ospf_priority_h_r1}

Modify OSPF Low Priority on R1
    Log    Reset OSPF protocol on R1
    SetCommand    ${R1}     ${set_ospf_priority_l_r1}

Modify OSPF High Priority on R2
    Log    Reset OSPF protocol on R2
    SetCommand    ${R2}     ${set_ospf_priority_h_r2}

Modify OSPF Low Priority on R2
    Log    Reset OSPF protocol on R2
    SetCommand    ${R2}     ${set_ospf_priority_l_r2}

Modify OSPF Router-id as higher value on R1
    Log    Modify OSPF Router-id as higher value on R1
    SetCommand    ${R1}     ${set_routerid_higher}

Modify MTU value on R1 same as R2
    Log    Modify MTU value on R1 same as R2
    SetCommand    ${R1}     ${modify_mtu_R1}

Validate OSPF neighbor status Full on R1
    Log     Validate OSPF neighbor status Full on R1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor status - Full on R1

Validate OSPF neighbor status Full on R2
    Log     Validate OSPF neighbor status Full on R2
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor status - Full on R2

Validate OSPF neighbor status Init on R1
    Log     Validate OSPF neighbor status Init on R1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor status - Init on R1

Validate OSPF neighbor status Init on R2
    Log     Validate OSPF neighbor status Init on R2
    Wait Until Keyword Succeeds    90 sec    1 sec    Validate OSPF neighbor status - Init on R2

Validate OSPF neighbor status ExStart on R1
    Log     Validate OSPF neighbor status ExStart on R1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor status - ExStart on R1

Validate OSPF neighbor status ExStart on R2
    Log     Validate OSPF neighbor status ExStart on R2
    Wait Until Keyword Succeeds    90 sec    2 sec    Validate OSPF neighbor status - ExStart on R2

Validate OSPF neighbor status Exchange on R1
    Log     Validate OSPF neighbor status Exchange on R1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor status - Exchange on R1

Validate OSPF neighbor status Exchange on R2
    Log     Validate OSPF neighbor status Exchange on R2
    Wait Until Keyword Succeeds    90 sec    2 sec    Validate OSPF neighbor status - Exchange on R2

Validate OSPF neighbor status 2-Way on R1
    Log     Validate OSPF neighbor status 2-Way on R1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor status - 2-Way on R1

Validate OSPF neighbor status 2-Way on R2
    Log     Validate OSPF neighbor status 2-Way on R2
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor status - 2-Way on R2

Validate OSPF neighbor election DR on R1
    Log     Validate OSPF neighbor election DR on R1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor election - DR on R1

Validate OSPF neighbor election DR on R2
    Log     Validate OSPF neighbor election DR on R2
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor election - DR on R2

Validate OSPF neighbor election DR on R3
    Log     Validate OSPF neighbor election DR on R3
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor election - DR on R3

Validate OSPF neighbor election Backup on R1
    Log     Validate OSPF neighbor election Backup on R1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor election - Backup on R1

Validate OSPF neighbor election Backup on R2
    Log     Validate OSPF neighbor election Backup on R2
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor election - Backup on R2

Validate OSPF neighbor election Backup on R3
    Log     Validate OSPF neighbor election Backup on R3
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor election - Backup on R3

Validate OSPF neighbor election DR on R2 with highest priority
    Log     Validate OSPF neighbor election DR on R2 with highest priority
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF neighbor election - DR on R2 with highest priority

Validate OSPF Database status Router LSA on R1
    Log    Validate OSPF Database status Router LSA on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_database_so}
    Log    ${output}
    Should Contain    ${output}   Router Link States (Area 0.0.0.0)
    Should Contain    ${output}   OSPF Router with ID (5.5.5.5)

Validate OSPF Database status Router LSA on Router-1
    Log    Validate OSPF Database status Router LSA on Router-1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF Database status Router LSA on R1

Validate OSPF Database status Router LSA on R2
    Log    Validate OSPF Database status Router LSA on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_database_so}
    Log    ${output}
    Should Contain    ${output}   Router Link States (Area 0.0.0.0)
    Should Contain    ${output}   OSPF Router with ID (2.2.2.2)

Validate OSPF Database status Router LSA on Router-2
    Log    Validate OSPF Database status Router LSA on Router-2
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF Database status Router LSA on R2

Validate OSPF Database status Network LSA on R1
    Log    Validate OSPF Database status Network LSA on R1
    ${output}    ShowCommand    ${R1}    ${show_ospf_database_nw}
    Log    ${output}
    Should Contain    ${output}   network-LSA
    Should Contain    ${output}   Link State ID: 41.1.1.3

Validate OSPF Database status Network LSA on Router-1
    Log    Validate OSPF Database status Network LSA on Router-1
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF Database status Network LSA on R1

Validate OSPF Database status Network LSA on R2
    Log    Validate OSPF Database status Network LSA on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_database_nw}
    Log    ${output}
    Should Contain    ${output}   network-LSA
    Should Contain    ${output}   Link State ID: 41.1.1.3
    Should Contain    ${output}   Link State ID: 51.1.1.4

Validate OSPF Database status Network LSA on Router-2
    Log    Validate OSPF Database status Network LSA on Router-2
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF Database status Network LSA on R2

Validate OSPF Database status Network LSA on R3
    Log    Validate OSPF Database status Network LSA on R3
    ${output}    ShowCommand    ${R3}    ${show_ospf_database_nw}
    Log    ${output}
    Should Contain    ${output}   network-LSA
    Should Contain    ${output}   Link State ID: 51.1.1.4

Validate OSPF Database status Network LSA on Router-3
    Log    Validate OSPF Database status Network LSA on Router-3
    Wait Until Keyword Succeeds    90 sec    5 sec    Validate OSPF Database status Network LSA on R3

Validate OSPF Database status on R1 in Multi-area
    Log    Validate OSPF Database status on R1 in Multi-area
    ${output}    ShowCommand    ${R1}    ${show_ospf_database}
    Log    ${output}
    Should Contain    ${output}   OSPF Router with ID (1.1.1.1)
    Should Contain    ${output}   Router Link States (Area 0.0.0.0)
    Should Contain    ${output}   Net Link States (Area 0.0.0.0)
    Should Contain    ${output}   Summary Link States (Area 0.0.0.0)

Validate OSPF Database status on R2 in Multi-area
    Log    Validate OSPF Database status Router LSA on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_database}
    Log    ${output}
    Should Contain    ${output}   OSPF Router with ID (2.2.2.2)
    Should Contain    ${output}   Router Link States (Area 0.0.0.0)
    Should Contain    ${output}   Net Link States (Area 0.0.0.0)
    Should Contain    ${output}   Summary Link States (Area 0.0.0.0)
    Should Contain    ${output}   Router Link States (Area 0.0.0.1)
    Should Contain    ${output}   Net Link States (Area 0.0.0.1)
    Should Contain    ${output}   Summary Link States (Area 0.0.0.1)

Validate OSPF Database status on R3 in Multi-area
    Log    Validate OSPF Database status Router LSA on R3
    ${output}    ShowCommand    ${R3}    ${show_ospf_database}
    Log    ${output}
    Should Contain    ${output}   OSPF Router with ID (3.3.3.3)
    Should Contain    ${output}   Router Link States (Area 0.0.0.1)
    Should Contain    ${output}   Net Link States (Area 0.0.0.1)
    Should Contain    ${output}   Summary Link States (Area 0.0.0.1)

Validate OSPF Database status ASBR-Summary on R3
    Log    Validate OSPF Database status Router LSA on R3
    ${output}    ShowCommand    ${R3}    ${show_ospf_database_as}
    Log    ${output}
    Should Contain    ${output}   ASBR-Summary Link States (Area 0.0.0.1)
    Should Contain    ${output}   OSPF Router with ID (3.3.3.3)

Validate OSPF Database status External on R3
    Log    Validate OSPF Database status Router LSA on R3
    ${output}    ShowCommand    ${R3}    ${show_ospf_database_ex}
    Log    ${output}
    Should Contain    ${output}   AS External Link States
    Should Contain    ${output}   OSPF Router with ID (3.3.3.3)

Validate OSPF Database status ASBR-Summary on R2
    Log    Validate OSPF Database status Router LSA on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_database_as}
    Log    ${output}
    Should Contain    ${output}   ASBR-Summary Link States (Area 0.0.0.0)
    Should Contain    ${output}   ASBR-Summary Link States (Area 0.0.0.1)
    Should Contain    ${output}   OSPF Router with ID (2.2.2.2)

Validate OSPF Database status External on R2
    Log    Validate OSPF Database status Router LSA on R2
    ${output}    ShowCommand    ${R2}    ${show_ospf_database_ex}
    Log    ${output}
    Should Contain    ${output}   AS External Link States
    Should Contain    ${output}   OSPF Router with ID (2.2.2.2)

Modify OSPF Router-id on R2 as same value on R1
    Log    Modify OSPF Router-id as higher value on R1
    SetCommand    ${R2}     ${set_routerid_sameas_R1}

Verify End-to-end reachability Successful from R1 to R2
        Log    Verify End-to-end reachability from R1 to R2
        Sleep  10s
        ${cmd}    Catenate    sudo ping -c1 ${R2_edge_iface_ip}
        ${output}    ShowCommand    ${R1}    ${cmd}
        Log    ${output}
        Should Not Contain    ${output}    100%

Verify End-to-end reachability Failed from R1 to R2
        Log    Verify End-to-end reachability from R1 to R2
        ${cmd}    Catenate    sudo ping -c1 ${R2_edge_iface_ip}
        ${output}    ShowCommand    ${R1}    ${cmd}
        Log    ${output}
        Should Contain    ${output}    100%

Verify End-to-end reachability Successful
    Log    Verify End-to-end reachability Successful
    Wait Until Keyword Succeeds    90 sec    2 sec    Verify End-to-end reachability Successful from R1 to R2

Verify End-to-end reachability Failed
    Log    Verify End-to-end reachability Failed
    Wait Until Keyword Succeeds    90 sec    2 sec    Verify End-to-end reachability Failed from R1 to R2

Disable interface on R1
    Log    Disable interface on R1
    SetCommand    ${R1}     ${set_intf_disable}

Enble interface on R1
    Log    Enble interface on R1
    DeleteCommand    ${R1}     ${set_intf_enable}
