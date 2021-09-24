# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
*** Settings ***
Library           SSHLibrary
Library           String
Library           Collections

*** Variables ***

*** Keywords ***
LoginToRouter
    [Arguments]    ${arg1}
    Open Connection   ${arg1}    prompt=$    alias=${arg1}    timeout=15
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
    FOR  ${line}  IN    Get From List    @{arg2}
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
    FOR  ${line}  IN    Get From List    @{arg2}
        ${cmd}    Catenate    delete    ${line}
        Log    ${cmd}
        Write    ${cmd}
        Read Until    \#
    END
    Write    commit
    Read Until    \#
    Write    exit
    Read Until    $

Access devices
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Access check to the device ${vm}
        LoginToRouter    ${vm}
    END

Access check and enable vymgmt support
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Access check and enable vymgmt support on ${vm}
        ShowCommand    ${vm}    ${access}[0]
        ${output}    ShowCommand    ${vm}    ${access}[1]
        Log    ${output}
        Should Contain    ${output}    DANOS:Shipping:2105
        #Should Contain    ${output}    -danos
    END

Clear configurations on the topology
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Delete configurations on ${vm}
        DeleteCommand    ${vm}    ${delete_config}
    END

Configure interfaces
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Configure interfaces on ${vm}
        ${config}    Set Variable If   '${vm}' == '${R1}'  ${R1_interface_config}
                     ...               '${vm}' == '${R2}'  ${R2_interface_config}
                     ...               '${vm}' == '${R3}'  ${R3_interface_config}
                     ...               '${vm}' == '${R4}'  ${R4_interface_config}
        SetCommand    ${vm}    ${config}
    END

Configure routing protocol
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Configure interfaces on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config}
                       ...               '${vm}' == '${R3}'  ${R3_protocol_config}
                       ...               '${vm}' == '${R4}'  ${R4_protocol_config}
        SetCommand    ${vm}    ${protocol}
    END

Route Reflector Rule-1 Configuration and verification
    Log    Rule-1: If a RR receives a NLRI from a non-RR client, the RR advertises the NLRI to a RR client. It does not advertise the NLRI to a non-route-reflector client.
    Log    R1=RR-Client, R2=RR, R3=NRR Client, R4=NRR-Client
    Log    Configure ${R1} as RR-Client in ${R2}
    Log    Advertise network from Non-RR client ${R3}
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Configure protocol on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config_RR_rule_1}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config_RR_rule_1}
                       ...               '${vm}' == '${R3}'  ${R3_protocol_config_RR_rule_1}
                       ...               '${vm}' == '${R4}'  ${R4_protocol_config_RR_rule_1}
        SetCommand    ${vm}    ${protocol}
    END
    Log    Verify NLRi is advertised to RR-Client in Route Reflector-${R2}. NLRi=Network layer reachability information
    ${output}    ShowCommand    ${R2}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R3R2_iface_ip}
    Log    Verify NLRi is received in RR-Client ${R1}
    ${output}    ShowCommand    ${R1}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R3R2_iface_ip}
    Log    Verify NLRi is NOT received in Non-RR-Client ${R4}
    ${output}    ShowCommand    ${R4}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Not Contain    ${output}    ${R3R2_iface_ip}
    Log    Delete configurations

# Validate Next-hop attribute. This validation is done with the provious test configurations
Validate Next-hop attribute
    Log    Validate Next-hop attribute on ${R1}
    ${output}    ShowCommand    ${R1}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R3R2_iface_ip}
    Log    Validate Next-hop attribute on ${R2}
    ${output}    ShowCommand    ${R2}    ${show_bgp_ipv4_unicast_hop}
    Log    ${output}
    Should Contain    ${output}    ${R3R2_iface_ip}
    DeleteCommand    ${R1}    ${del}
    DeleteCommand    ${R3}    ${del}
    DeleteCommand    ${R3}    ${del}
    DeleteCommand    ${R4}    ${del}

Route Reflector Rule-2 Configuration and verification
    Log    Rule-2: If a RR receives a NLRI from a RR client, it advertises the NLRI to RR client(s) and non-RR client(s). Even the RR client that sent the advertisement receives a copy of the route, but it discards the NLRI because it sees itself as the route originator.
    Log    R1=RR-Client, R2=RR, R3=RR-Client, R4=NRR Client
    Log    Configure ${R1} and ${R3} as RR-Client in ${R2}
    Log    Advertise network from RR-Client ${R1}
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Configure protocol on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config_RR_rule_2}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config_RR_rule_2}
                       ...               '${vm}' == '${R3}'  ${R3_protocol_config_RR_rule_2}
                       ...               '${vm}' == '${R4}'  ${R4_protocol_config_RR_rule_2}
        SetCommand    ${vm}    ${protocol}
    END
    # Sleep for 5 seconds for convergence
    Sleep    5
    Log    Verify NLRi is advertised to RR-Client in Route Reflector-${R2}. NLRi=Network layer reachability information
    ${output}    ShowCommand    ${R2}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R1R2_iface_ip}
    Log    Verify NLRi is received in RR-Client ${R3}
    ${output}    ShowCommand    ${R3}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R1R2_iface_ip}
    Log    Verify NLRi is also received in Non-RR-Client ${R4}
    ${output}    ShowCommand    ${R4}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R1R2_iface_ip}
    Log    Delete configurations
    DeleteCommand    ${R1}    ${del}
    DeleteCommand    ${R2}    ${del}
    DeleteCommand    ${R3}    ${del}
    DeleteCommand    ${R4}    ${del}

Route Reflector Rule-3 Configuration and verification
    Log    Rule-3: If a RR receives a route from an EBGP peer, it advertises the route to RR client(s) and non-RR client(s).
    Log    R1=RR-Client, R2=RR, R3=EBGP Peer, R4=NRR Client
    Log    Clear configurations on R2 and R3 before proceeding configurations
    Log    Configure EBGP between ${R2} and ${R3}
    Log    Configure ${R1} as RR-Client in ${R2}
    Log    Advertise network from EBGP Peer ${R3}
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Configure protocol on ${vm}
        ${protocol}    Set Variable If   '${vm}' == '${R1}'  ${R1_protocol_config_RR_rule_3}
                       ...               '${vm}' == '${R2}'  ${R2_protocol_config_RR_rule_3}
                       ...               '${vm}' == '${R3}'  ${R3_protocol_config_RR_rule_3}
                       ...               '${vm}' == '${R4}'  ${R4_protocol_config_RR_rule_3}
        SetCommand    ${vm}    ${protocol}
    END
    # Sleep for 5 seconds for convergence
    Sleep    5
    Log    Verify route is advertised to RR-Client in Route Reflector-${R2}
    ${output}    ShowCommand    ${R2}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R3R2_iface_ip}
    Log    Verify route is received in RR-Client ${R1}
    ${output}    ShowCommand    ${R1}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R3R2_iface_ip}
    Log    Verify route is also received in Non-RR-Client ${R4}
    ${output}    ShowCommand    ${R4}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R3R2_iface_ip}
    Log    Delete configurations
    DeleteCommand    ${R1}    ${del}
    DeleteCommand    ${R2}    ${del}
    DeleteCommand    ${R3}    ${del}
    DeleteCommand    ${R4}    ${del}

Verify EBGP on directly connected neighbors
    Log    R1<----->R2
    Log    Configure EBGP on ${R1} and ${R2}
    SetCommand    ${R1}    ${R1_protocol_config_ebgp_directconnect}
    SetCommand    ${R2}    ${R2_protocol_config_ebgp_directconnect}
    # Sleep for 5 seconds for convergence
    Sleep    5
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Verify BGP neighbor on ${vm}
        ${output}    ShowCommand    ${vm}    ${show_bgp_neighbor}
        Log    ${output}
        Should Not Contain    ${output}    Active
        Log    Verify End-to-end reachability from ${vm}
        ${dest_ip}=    Set Variable If   '${vm}' == '${R1}'    ${R2R1_iface_ip}
                       ...               '${vm}' == '${R2}'    ${R1R2_iface_ip}
        ${cmd}    Catenate    sudo ping -c1 ${dest_ip}
        ShowCommand    ${vm}    ${cmd}
        ${output}    ShowCommand    ${vm}    ${cmd}
        Log    ${output}
        Should Not Contain    ${output}    100%
    END
    DeleteCommand    ${R1}    ${del}
    DeleteCommand    ${R2}    ${del}

Verify EBGP Neighbor with Multihop option
    Log    R1<----->R2<----->R3
    Log    Configure EBGP on ${R1} and ${R3} add static route
    SetCommand    ${R1}    ${R1_protocol_config_ebgp_multihop}
    SetCommand    ${R3}    ${R3_protocol_config_ebgp_multihop}
    # Sleep for 5 seconds for convergence. #REQUIRED
    Sleep    5
    FOR  ${vm}  IN    ${R1}    ${R3}
        Log    Verify BGP neighbor on ${vm}
        ${output}    ShowCommand    ${vm}    ${show_bgp_neighbor}
        Log    ${output}
        Should Not Contain    ${output}    Active
        Log    Verify End-to-end reachability from ${vm}
        ${dest_ip}=    Set Variable If   '${vm}' == '${R1}'    ${R3R2_iface_ip}
                       ...               '${vm}' == '${R3}'    ${R1R2_iface_ip}
        ${cmd}    Catenate    sudo ping -c1 ${dest_ip}
        ShowCommand    ${vm}    ${cmd}
        ${output}    ShowCommand    ${vm}    ${cmd}
        Log    ${output}
        Should Not Contain    ${output}    100%
    END
    DeleteCommand    ${R1}    ${del}
    DeleteCommand    ${R3}    ${del}

Verify iBGP on directly connected neighbors
    Log    R1<----->R2
    Log    Configure iBGP on ${R1} and ${R2}
    SetCommand    ${R1}    ${R1_protocol_config_ibgp_directconnect}
    SetCommand    ${R2}    ${R2_protocol_config_ibgp_directconnect}
    # Sleep for 5 seconds for convergence. #REQUIRED
    Sleep    5
    FOR  ${vm}  IN    ${R1}    ${R2}
        Log    Verify BGP neighbor on ${vm}
        ${output}    ShowCommand    ${vm}    ${show_bgp_neighbor}
        Log    ${output}
        Should Not Contain    ${output}    Active
        Log    Verify End-to-end reachability from ${vm}
        ${dest_ip}=    Set Variable If   '${vm}' == '${R1}'    ${R2R1_iface_ip}
                       ...               '${vm}' == '${R2}'    ${R1R2_iface_ip}
        ${cmd}    Catenate    sudo ping -c1 ${dest_ip}
        ShowCommand    ${vm}    ${cmd}
        ${output}    ShowCommand    ${vm}    ${cmd}
        Log    ${output}
        Should Not Contain    ${output}    100%
    END
    DeleteCommand    ${R1}    ${del}
    DeleteCommand    ${R2}    ${del}

Verify iBGP Neighbor with Multihop option
    Log    R1<----->R2<----->R3
    Log    Configure iBGP on ${R1} and ${R3}
    Log    Configure OSPF on ${R1}, ${R2} and ${R3}
    SetCommand    ${R1}    ${R1_protocol_config_ibgp_multihop}
    SetCommand    ${R2}    ${R2_protocol_config_ibgp_multihop}
    SetCommand    ${R3}    ${R3_protocol_config_ibgp_multihop}
    # REQUIRED: Sleep for 40 seconds for OSPF convergence
    Sleep    40
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
        Log    Verify OSPF status on ${vm}
        ${output}    ShowCommand    ${vm}    ${show_ospf_neighbor}
        Log    ${output}
        Should Contain    ${output}    Full
    END
    FOR  ${vm}  IN    ${R1}    ${R3}
        Log    Verify BGP neighbor on ${vm}
        ${output}    ShowCommand    ${vm}    ${show_bgp_neighbor}
        Log    ${output}
        Should Not Contain    ${output}    Active
        Log    Verify End-to-end reachability from ${vm}
        ${dest_ip}=    Set Variable If   '${vm}' == '${R1}'    ${R3R2_iface_ip}
                       ...               '${vm}' == '${R3}'    ${R1R2_iface_ip}
        ${cmd}    Catenate    sudo ping -c1 ${dest_ip}
        ShowCommand    ${vm}    ${cmd}
        ${output}    ShowCommand    ${vm}    ${cmd}
        Log    ${output}
        Should Not Contain    ${output}    100%
    END
    DeleteCommand    ${R1}    ${del}
    DeleteCommand    ${R2}    ${del}
    DeleteCommand    ${R3}    ${del}
    DeleteCommand    ${R3}    ${del}

Validate BGP route selection between iBGP v/s eBGP
    Log     /--eBGP--R4--iBGP-\
    Log    R1--eBGP--R2--iBGP--R3
    Log    R1=AS100, R2,R3=AS200, R3=AS400
    Log    Configure Interfaces and protocols on all routers
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Configure interfaces and protocols on ${vm}
        ${config}    Set Variable If   '${vm}' == '${R1}'  ${R1_config_best_path}
                     ...               '${vm}' == '${R2}'  ${R2_config_best_path}
                     ...               '${vm}' == '${R3}'  ${R3_config_best_path}
                     ...               '${vm}' == '${R4}'  ${R4_config_best_path}
        SetCommand    ${vm}    ${config}
    END
    Log    Configure new network on ${R1}
    SetCommand    ${R1}    ${R1_config_best_path_new_nw}
    # Sleep 40 sec for convergence # REQUIRED
    Sleep    40
    Log    Verify two routing paths displayed on ${R3} for reaching ${R1_rr_ip}
    Wait Until Keyword Succeeds    60 sec    5 sec    Chk
    Log    Disable the eBGP path (R3-R4) by shutdowning it on ${R3}
    Log    Verify the best path choosen is the eBGP path on ${R3} for reaching ${R1_rr_ip}
    ${output}    ShowCommand    ${R3}    ${show_bgp_ipv4_unicast}
    Log    ${output}
    Should Contain    ${output}    ${R4BgpID} ${R1BgpID} i
    SetCommand    ${R3}    ${R3_config_best_path_shutdown}
    Log    Verify only one routing path displayed on ${R3} for reaching ${R1_rr_ip}
    ${output}    ShowCommand    ${R3}    ${show_bgp_ipv4_unicast_ip}
    Log    ${output}
    Should Contain    ${output}    ${R1R2_iface_ip} from ${lo20_ip}
    Should Not Contain    ${output}    ${R4R3_iface_ip} from ${R4R3_iface_ip} (${R4R1_iface_ip})
    DeleteCommand    ${R3}    ${R3_config_best_path_shutdown}

Chk
    ${output}    ShowCommand    ${R3}    ${show_bgp_ipv4_unicast_ip}
    Log    ${output}
    Should Contain    ${output}    ${R1R2_iface_ip} from ${lo20_ip}
    Should Contain    ${output}    ${R4R3_iface_ip} from ${R4R3_iface_ip} (${R4R1_iface_ip})

# Verify local preference. This validation is done with the provious test configurations
Verify local preference
    Log    Verify local preference expected before
    ${output}    ShowCommand    ${R3}    show ip route
    Log    ${output}
    Should Contain    ${output}    ${local_pref_expected_before}
    Log    Apply local preference and reset bgp
    SetCommand    ${R3}    ${apply_local_preference}
    ShowCommand    ${R3}    ${reset_bgp}
    # Sleep 5 sec for convergence # REQUIRED
    Sleep    5
    Log    Verify local preference expected after
    ${output}    ShowCommand    ${R3}    show ip route
    Log    ${output}
    Should Contain    ${output}    ${local_pref_expected_after}

Validate BGP confederation
    Log     /--eBGP------R4(AS200)------eBGP-\
    Log    R1(AS100)--eBGP--R2(AS200)--eBGP--R3(AS200)
    Log    R1=AS100, R2,R3,R4=AS200 R2SubAS=6700 R3SubAS=6600 R4SubAS=6500
    Log    Configure Interfaces and protocols on all routers
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Configure interfaces and protocols on ${vm}
        ${config}    Set Variable If    '${vm}' == '${R1}'  ${R1_confederation}
                     ...                '${vm}' == '${R2}'  ${R2_confederation}
                     ...                '${vm}' == '${R3}'  ${R3_confederation}
                     ...                '${vm}' == '${R4}'  ${R4_confederation}
        SetCommand    ${vm}    ${config}
    END
    Log    Configure new network on ${R1}
    SetCommand    ${R1}    ${R1_config_best_path_new_nw}
    # Sleep 40 sec for convergence # REQUIRED (40: DANOS2009, 120: DANOS2105)
    Sleep    120
    Log    Verify subAS NOT displayed on edge routers R2 & R4 for reaching ${R1_rr_ip}
    ${output}    ShowCommand    ${R2}    ${show_bgp_ipv4_unicast_ip}
    Log    ${output}
    Should Contain    ${output}    ${R1BgpID}
    Should Not Contain    ${output}    6700
    ${output}    ShowCommand    ${R4}    ${show_bgp_ipv4_unicast_ip}
    Log    ${output}
    Should Contain    ${output}    ${R1BgpID}
    Should Not Contain    ${output}    6500
    Log    Verify subAS displayed on internal router R3 for reaching ${R1_rr_ip}
    ${output}    ShowCommand    ${R3}    ${show_bgp_ipv4_unicast_ip}
    Log    ${output}
    Should Contain    ${output}    ${R1BgpID}
    Should Contain    ${output}    6700

# Verify Route Flaping/dampening Feature. This validation is done with the provious test configurations
# https://sites.google.com/site/amitsciscozone/home/bgp/bgp-route-dampening
Verify Route Flaping/dampening Feature
    Log    Configure router dampening on ${R4}
    SetCommand    ${R4}    ${R4_apply_route_dampening}
    Log    Delete network on ${R1}
    DeleteCommand    ${R1}    ${R1_nw}
    Log    First flap: Verify route flapping on ${R4} and the flap count should be 1
    ${output}    ShowCommand    ${R4}    ${route_flapping}
    Log    ${output}
    Should Contain    ${output}    h ${R1_rr_ip}/32   ${R1R4_iface_ip}       1
    Log    Configure network on ${R1}
    SetCommand    ${R1}    ${R1_nw}
    # Sleep 5 sec for convergence # REQUIRED
    Sleep    5
    Log    Validate routing on ${R4}
    ${output}    ShowCommand    ${R4}    show ip route
    Log    ${output}
    Should Contain    ${output}    ${R1_rr_ip}/32 [20/0] via ${R1R4_iface_ip}
    Log    Delete network on ${R1} again
    DeleteCommand    ${R1}    ${R1_nw}
    # Sleep 5 sec for convergence # REQUIRED
    Sleep    5
    Log    Second flap: Verify route flapping on ${R4} and the flap count should be 2
    ${output}    ShowCommand    ${R4}    ${route_flapping}
    Log    ${output}
    Should Contain    ${output}    h ${R1_rr_ip}/32   ${R1R4_iface_ip}       2
    # Validate dempening
    Log    Configure network on ${R1}
    SetCommand    ${R1}    ${R1_nw}
    # Sleep 5 sec for convergence # REQUIRED
    Sleep    5
    ${output}    ShowCommand    ${R4}    ${route_flapping}
    Log    ${output}
    Should Contain    ${output}    > ${R1_rr_ip}/32   ${R1R4_iface_ip}       2
    Log    Delete network on ${R1} and set it again to check the dampening
    DeleteCommand    ${R1}    ${R1_nw}
    SetCommand    ${R1}    ${R1_nw}
    # Sleep 5 sec for convergence # REQUIRED
    Sleep    5
    Log    Verify route dampening on ${R4}
    Log    Third flap: Verify route dampening on ${R4} and the flap count should be 3 and tag d
    ${output}    ShowCommand    ${R4}    ${route_flapping}
    Log    ${output}
    Should Contain    ${output}    d ${R1_rr_ip}/32   ${R1R4_iface_ip}       3

Show Interfaces
    FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}    ${R4}
        Log    Show Interfaces on ${vm}
        ${output}    ShowCommand    ${vm}    show interfaces
        Log    ${output}
    END
