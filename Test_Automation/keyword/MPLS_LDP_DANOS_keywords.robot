# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
*** Settings ***
Variables         ../variable/MPLS_LDP_DANOS_Variables.py
Library           SSHLibrary
Library           String
Library           Collections
Library           ../library/danos_cli.py

*** Variables ***
${vpnif}   .spathintf
${dest1}   ${PE1H1interfaceIP}
${dest2}   ${PE2H2interfaceIP}

*** Keywords ***
Access check and enable vymgmt support
    :FOR  ${vm}  IN    ${PE1}    ${P1}    ${PE2}
    \    Log    Access check and enable vymgmt support on ${vm}
    \    ${id}    Open Connection   ${vm}    prompt=$    alias=${vm}    timeout=15
    \    Login   ${user}    ${pa}
    \    Execute Command   touch .hushlogin
    \    Write    show version
    \    ${o}    Read Until    $
    \    Log    ${o}
    \    Should Contain    ${o}    danos-
    \    Log    Access to ${vm} is successful and enabled vymgmt support
    \    Close All Connections

Clear configurations on the topology
    :FOR  ${vm}  IN    ${PE1}    ${P1}    ${PE2}
    \    Log    Clear configurations on ${vm}
    \    ${id}    Open Connection   ${vm}    prompt=$    alias=${vm}    timeout=15
    \    Login   ${user}    ${pa}
    \    Write    configure
    \    ${o}    Read Until    \#
    \    Write    delete interfaces
    \    ${o}    Read Until    \#
    \    Write    delete protocols mpls-ldp
    \    ${o}    Read Until    \#
    \    Write    delete protocols ospf
    \    ${o}    Read Until    \#
    \    Write    delete security vpn
    \    ${o}    Read Until    \#
    \    Write    commit
    \    ${o}    Read Until    \#
    \    Close All Connections

ShowService
    [Arguments]    ${arg1}    ${arg2}    ${arg3}    ${arg4}
    Open Connection   ${arg1}    prompt=$    alias=${arg1}    timeout=15
    Login   ${arg2}    ${arg3}
    Write    configure
    ${o}    Read Until    \#
    Write    ${arg4}
    ${o}    Read Until    \#
    Close All Connections
    ${o2}    Split String    ${o}    "\n"
    [Return]    ${o2}

Configure PE1 interfaces
    Log    Configure PE1 interfaces
    danos_cli.config_mplsldp    ${PE1}   ${user}    ${pa}    ${PE1_interface_config}

Configure P1 interfaces
    Log    Configure P1 interfaces
    danos_cli.config_mplsldp    ${P1}   ${user}    ${pa}    ${P1_interface_config}

Configure PE2 interfaces
    Log    Configure PE2 interfaces
    danos_cli.config_mplsldp    ${PE2}   ${user}    ${pa}    ${PE2_interface_config}

Configure routing protocol on PE1
    Log    Configure OSPF on PE1
    danos_cli.config_mplsldp    ${PE1}   ${user}    ${pa}    ${PE1_ospf_protocol_config}

Configure routing protocol on P1
    Log    Configure OSPF on P1
    danos_cli.config_mplsldp    ${P1}   ${user}    ${pa}    ${P1_ospf_protocol_config}

Configure routing protocol on PE2
    Log    Configure OSPF on PE2
    danos_cli.config_mplsldp    ${PE2}   ${user}    ${pa}    ${PE2_ospf_protocol_config}

Configure MPLS LDP on PE1
    Log    Configure MPLS LDP on PE1
    danos_cli.config_mplsldp    ${PE1}   ${user}    ${pa}    ${PE1_mpls_ldp_config}

Configure MPLS LDP on P1
    Log    Configure MPLS LDP on P1
    danos_cli.config_mplsldp    ${P1}   ${user}    ${pa}    ${P1_mpls_ldp_config}

Configure MPLS LDP on PE2
    Log    Configure MPLS LDP on PE2
    danos_cli.config_mplsldp    ${PE2}   ${user}    ${pa}    ${PE2_mpls_ldp_config}

Verify connectivity from PE1
    :FOR  ${ip}  IN  @{PE1_pingcheck}
    \    Log    Verify pinging interface IPs from ${ip}
    \    ${c1}    Catenate    ping -c1     ${ip}
    \    ShowService    ${PE1}   ${user}    ${pa}    ${c1}
    \    ${cmd}    Catenate    ping -c1     ${ip}
    \    ${output}    ShowService    ${PE1}   ${user}    ${pa}    ${c1}
    \    danos_cli.pr    ${output}
    \    ${o}    Evaluate    ''.join(${output})
    \    Should Not Contain    ${o}    100%

Verify connectivity from P1
    :FOR  ${ip}  IN  @{P1_pingcheck}
    \    Log    Verify pinging interface IPs from ${ip}
    \    ${c1}    Catenate    ping -c1     ${ip}
    \    ShowService    ${P1}   ${user}    ${pa}    ${c1}
    \    ${cmd}    Catenate    ping -c1     ${ip}
    \    ${output}    ShowService    ${P1}   ${user}    ${pa}    ${c1}
    \    danos_cli.pr    ${output}
    \    ${o}    Evaluate    ''.join(${output})
    \    Should Not Contain    ${o}    100%

Verify connectivity from PE2
    :FOR  ${ip}  IN  @{PE2_pingcheck}
    \    Log    Verify pinging interface IPs from ${ip}
    \    ${c1}    Catenate    ping -c1     ${ip}
    \    ShowService    ${PE2}   ${user}    ${pa}    ${c1}
    \    ${cmd}    Catenate    ping -c1     ${ip}
    \    ${output}    ShowService    ${PE2}   ${user}    ${pa}    ${c1}
    \    danos_cli.pr    ${output}
    \    ${o}    Evaluate    ''.join(${output})
    \    Should Not Contain    ${o}    100%

Verify E2E reachability from PE1
    Log    Verify E2E reachability from PE1
    ${cmd}    Catenate    ping -c2     ${PE1_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show_mplsldp    ${PE1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    100%

Verify E2E reachability from PE2
    Log    Verify E2E reachability from PE2
    ${cmd}    Catenate    ping -c2     ${PE2_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show_mplsldp    ${PE2}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    100%

Validate OSPF status on PE1
    Log    Validate OSPF status on PE1
    ${output}    ShowService    ${PE1}   ${user}    ${pa}    ${validate_ospf_status}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    Full

Validate OSPF status on PE2
    Log    Validate OSPF status on PE2
    ${output}    ShowService    ${PE2}   ${user}    ${pa}    ${validate_ospf_status}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    Full

Validate MPLS-LDP Neighbor status
    :FOR  ${ip}  IN    ${PE1}    ${P1}    ${PE2}
    \    Log    Validate MPLS-LDP Neighbor status on ${ip}
    \    ${output}    ShowService    ${ip}   ${user}    ${pa}    ${validate_mpls_ldp_neighbor}
    \    danos_cli.pr    ${output}
    \    ${o}    Evaluate    ''.join(${output})
    \    Should Contain    ${o}    OPERATIONAL

Validate MPLS-LDP IPv4 interface status
    :FOR  ${ip}  IN    ${PE1}    ${P1}    ${PE2}
    \    Log    Validate MPLS-LDP IPv4 interface status on ${ip}
    \    ${output}    ShowService    ${ip}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_interface}
    \    danos_cli.pr    ${output}
    \    ${o}    Evaluate    ''.join(${output})
    \    Should Contain    ${o}    ACTIVE

Validate MPLS-LDP IPv4 discovery status on PE1
    Log    Validate MPLS-LDP IPv4 discovery status on PE1
    ${output}    ShowService    ${PE1}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_discovery}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${P1ID}
    Should Contain    ${o}    ${PE2ID}
    Should Not Contain    ${o}    ${PE1ID}

Validate MPLS-LDP IPv4 discovery status on P1
    Log    Validate MPLS-LDP IPv4 discovery status on P1
    ${output}    ShowService    ${P1}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_discovery}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${PE1ID}
    Should Contain    ${o}    ${PE2ID}
    Should Not Contain    ${o}    ${P1ID}

Validate MPLS-LDP IPv4 discovery status on PE2
    Log    Validate MPLS-LDP IPv4 discovery status on PE2
    ${output}    ShowService    ${PE2}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_discovery}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${PE1ID}
    Should Contain    ${o}    ${P1ID}
    Should Not Contain    ${o}    ${PE2ID}

Validate MPLS-LDP IPv4 binding status on PE1
    Log    Validate MPLS-LDP IPv4 binding status on PE1
    ${o1}    Replace String    ${PE1_binding_chk}    PE1ID    ${PE1ID}
    ${PE1_binding_chk}    Replace String    ${o1}    P1ID    ${P1ID}
    ${output}    ShowService    ${PE1}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_binding}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${PE1_binding_chk}

Validate MPLS-LDP IPv4 binding status on P1
    Log    Validate MPLS-LDP IPv4 binding status on P1
    ${o1}    Replace String    ${P1_binding_chk1}    P1ID    ${P1ID}
    ${P1_binding_chk1}    Replace String    ${o1}    PE1ID    ${PE1ID}
    ${oo1}    Replace String    ${P1_binding_chk2}    P1ID    ${P1ID}
    ${P1_binding_chk2}    Replace String    ${oo1}    PE2ID    ${PE2ID}
    ${output}    ShowService    ${P1}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_binding}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${P1_binding_chk1}
    Should Contain    ${o}    ${P1_binding_chk2}

Validate MPLS-LDP IPv4 binding status on PE2
    Log    Validate MPLS-LDP IPv4 binding status on PE2
    ${o1}    Replace String    ${PE2_binding_chk}    PE2ID    ${PE2ID}
    ${PE2_binding_chk}    Replace String    ${o1}    P1ID    ${P1ID}
    ${output}    ShowService    ${PE2}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_binding}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${PE2_binding_chk}
