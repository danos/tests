# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# * All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
*** Settings ***
#Variables         ../variable/IPSEC_VPN_DANOS_Variables.py
Library           SSHLibrary
Library           String
Library           Collections
Library           ../library/danos_cli.py

*** Variables ***
${vpnif}   .spathintf
${dest1}   ${R1H1interfaceIP}
${dest2}   ${R3H2interfaceIP}

*** Keywords ***
Access check and enable vymgmt support
    :FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
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
    :FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
    \    Log    Clear configurations on ${vm}
    \    ${id}    Open Connection   ${vm}    prompt=$    alias=${vm}    timeout=15
    \    Login   ${user}    ${pa}
    \    Write    configure
    \    ${o}    Read Until    \#
    \    Write    delete interfaces
    \    ${o}    Read Until    \#
    \    Write    delete security vpn ipsec
    \    ${o}    Read Until    \#
    \    Write    delete protocols ospf
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

Configure R1 interfaces
    Log    Configure R1 interfaces
    danos_cli.config_ipsecvpn    ${R1}   ${user}    ${pa}    ${R1_interface_config}

Configure R2 interfaces
    Log    Configure R2 interfaces
    danos_cli.config_ipsecvpn    ${R2}   ${user}    ${pa}    ${R2_interface_config}

Configure R3 interfaces
    Log    Configure R3 interfaces
    danos_cli.config_ipsecvpn    ${R3}   ${user}    ${pa}    ${R3_interface_config}

Configure routing protocol on R1
    Log    Configure OSPF on R1
    danos_cli.config_ipsecvpn    ${R1}   ${user}    ${pa}    ${R1_protocol_config}

Configure routing protocol on R2
    Log    Configure OSPF on R2
    danos_cli.config_ipsecvpn    ${R2}   ${user}    ${pa}    ${R2_protocol_config}

Configure routing protocol on R3
    Log    Configure OSPF on R3
    danos_cli.config_ipsecvpn    ${R3}   ${user}    ${pa}    ${R3_protocol_config}

Configure R1 interface tunnel
    Log    Configure R1 interface tunnel
    danos_cli.config_ipsecvpn    ${R1}   ${user}    ${pa}    ${R1_interface_tunnel_config}

Configure R3 interface tunnel
    Log    Configure R3 interface tunnel
    danos_cli.config_ipsecvpn    ${R3}   ${user}    ${pa}    ${R3_interface_tunnel_config}

Configure R1 IPSEC VPN
    Log    Configure R1 IPSEC VPN
    danos_cli.config_ipsecvpn    ${R1}   ${user}    ${pa}    ${R1_ipsec_vpn_config}

Configure R3 IPSEC VPN
    Log    Configure R3 IPSEC VPN
    danos_cli.config_ipsecvpn    ${R3}   ${user}    ${pa}    ${R3_ipsec_vpn_config}

Verify connectivity from R1
    :FOR  ${ip}  IN  @{R1_pingcheck}
    \    Log    Verify pinging interface IPs from ${ip}
    \    ${c1}    Catenate    ping -c1     ${ip}
    \    ShowService    ${R1}   ${user}    ${pa}    ${c1}
    # This is not working from  jenkins and hence using ShowService method
    #\    danos_cli.config_show_ipsecvpn    ${R1}   ${user}    ${pa}    ${c1}
    \    ${cmd}    Catenate    ping -c1     ${ip}
    \    ${output}    ShowService    ${R1}   ${user}    ${pa}    ${c1}
    #\    ${output}    danos_cli.config_show_ipsecvpn    ${R1}   ${user}    ${pa}    ${cmd}
    \    danos_cli.pr    ${output}
    \    ${o}    Evaluate    ''.join(${output})
    \    Should Not Contain    ${o}    100%

Verify connectivity from R2
    :FOR  ${ip}  IN  @{R2_pingcheck}
    \    Log    Verify pinging interface IPs from ${ip}
    \    ${c1}    Catenate    ping -c1     ${ip}
    \    ShowService    ${R2}   ${user}    ${pa}    ${c1}
    \    ${cmd}    Catenate    ping -c1     ${ip}
    \    ${output}    ShowService    ${R2}   ${user}    ${pa}    ${c1}
    \    danos_cli.pr    ${output}
    \    ${o}    Evaluate    ''.join(${output})
    \    Should Not Contain    ${o}    100%

Verify connectivity from R3
    :FOR  ${ip}  IN  @{R3_pingcheck}
    \    Log    Verify pinging interface IPs from ${ip}
    \    ${c1}    Catenate    ping -c1     ${ip}
    \    ShowService    ${R3}   ${user}    ${pa}    ${c1}
    \    ${cmd}    Catenate    ping -c1     ${ip}
    \    ${output}    ShowService    ${R3}   ${user}    ${pa}    ${c1}
    \    danos_cli.pr    ${output}
    \    ${o}    Evaluate    ''.join(${output})
    \    Should Not Contain    ${o}    100%

Verify E2E reachability from R1
    Log    Verify E2E reachability from R1
    ${cmd}    Catenate    ping -c2     ${R1_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show_ipsecvpn    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    100%

Verify E2E reachability from R3
    Log    Verify E2E reachability from R3
    ${cmd}    Catenate    ping -c2     ${R3_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show_ipsecvpn    ${R3}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    100%

Send traffic and validate it is received
    Log   Send ICMP traffic from source IP ${dest1} to destination IP ${dest2}
    danos_cli.sendping    ${R1}   ${user}    ${pa}    ${dest2}

    Log   Verify traffic on VPN interface ${vpnif} at the destination ${dest2}
    ${output}    danos_cli.capture_traffic    ${R3}   ${user}    ${pa}    .spathintf
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${dest1}
    Should Contain    ${o}    ${dest2}

Validate VPN traffic is encrypted in the network
    Log   Verify traffic is encrypted on the main interfaces of the routers
    # On R1
    ${output}    danos_cli.capture_traffic    ${R1}   ${user}    ${pa}    ${R1R2interface}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${output}    ${dest1}
    Should Not Contain    ${output}    ${dest2}
    Should Contain    ${o}    ESP

    # On R2
    ${output}    danos_cli.capture_traffic    ${R2}   ${user}    ${pa}    ${R2R3interface}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${output}    ${dest1}
    Should Not Contain    ${output}    ${dest2}
    Should Contain    ${o}    ESP

    # On R3
    ${output}    danos_cli.capture_traffic    ${R3}   ${user}    ${pa}    ${R3R2interface}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${output}    ${dest1}
    Should Not Contain    ${output}    ${dest2}
    Should Contain    ${o}    ESP

Validate OSPF status on R1
    Log    Validate OSPF status on R1
    ${output}    ShowService    ${R1}   ${user}    ${pa}    ${validate_ospf_status}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    Full

Validate OSPF status on R3
    Log    Validate OSPF status on R3
    ${output}    ShowService    ${R3}   ${user}    ${pa}    ${validate_ospf_status}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    Full

Validate VPN tunnel status on R1
    Log    VPN tunnel status on R1
    ${output}    ShowService    ${R1}   ${user}    ${pa}    ${validate_vpn_tunnel_status}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    up

Validate VPN tunnel status on R3
    Log    VPN tunnel status on R3
    ${output}    ShowService    ${R3}   ${user}    ${pa}    ${validate_vpn_tunnel_status}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    up

Validate VPN IPSEC status on R1
    Log    VPN IPSEC status on R1
    ${output}    ShowService    ${R1}   ${user}    ${pa}    ${validate_vpn_ipsec_status}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    Running PID

Validate VPN IPSEC status on R3
    Log    VPN IPSEC status on R3
    ${output}    ShowService    ${R3}   ${user}    ${pa}    ${validate_vpn_ipsec_status}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    Running PID
