# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Settings ***
Variables         ../testdata/FIREWALL_DANOS_testdata.py
Library           SSHLibrary
Library           String
Library           Collections
Library           ../library/danos_cli.py

*** Variables ***
${user}    vyatta
${pa}      vyatta
${vpnif}   .spathintf
${dest1}   10.1.1.1
${dest2}   172.16.1.1

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
    \    Should Contain    ${o}    2105
    \    Log    Access to ${vm} is successful and enabled vymgmt support
    \    Close All Connections

Clear configurations on the topology
    :FOR  ${vm}  IN    ${R1}    ${R2}    ${R3}
    \    Log    Clear configurations on ${vm}
    \    ${id}    Open Connection   ${vm}    prompt=$    alias=${vm}    timeout=15
    \    Login   ${user}    ${pa}
    \    Write    configure
    \    ${o}    Read Until    \#
    \    Write    delete interfaces dataplane
    \    ${o}    Read Until    \#
    \    Write    delete protocols mpls-ldp
    \    ${o}    Read Until    \#
    \    Write    delete protocols ospf
    \    ${o}    Read Until    \#
    \    Write    delete security vpn
    \    ${o}    Read Until    \#
    \    Write    delete security firewall
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
    danos_cli.config    ${R1}   ${user}    ${pa}    ${R1_interface_config}

Configure R2 interfaces
    Log    Configure R2 interfaces
    danos_cli.config    ${R2}   ${user}    ${pa}    ${R2_interface_config}

Configure R3 interfaces
    Log    Configure R3 interfaces
    danos_cli.config    ${R3}   ${user}    ${pa}    ${R3_interface_config}

Configure routing protocol on R1
    Log    Configure OSPF on R1
    danos_cli.config    ${R1}   ${user}    ${pa}    ${R1_ospf_protocol_config}

Configure routing protocol on R2
    Log    Configure OSPF on R2
    danos_cli.config    ${R2}   ${user}    ${pa}    ${R2_ospf_protocol_config}

Configure routing protocol on R3
    Log    Configure OSPF on R3
    danos_cli.config    ${R3}   ${user}    ${pa}    ${R3_ospf_protocol_config}

Verify connectivity from R1
    :FOR  ${ip}  IN  @{R1_pingcheck}
    \    Log    Verify pinging interface IPs from ${ip}
    \    ${c1}    Catenate    ping -c1     ${ip}
    \    ShowService    ${R1}   ${user}    ${pa}    ${c1}
    \    ${cmd}    Catenate    ping -c1     ${ip}
    \    ${output}    ShowService    ${R1}   ${user}    ${pa}    ${c1}
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
    ${output}    danos_cli.config_show    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    100%

Verify E2E reachability from R3
    Log    Verify E2E reachability from R3
    ${cmd}    Catenate    ping -c2     ${R3_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show    ${R3}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    100%

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

Create Firewall rule for blocking ICMP
    Log    Create Firewall rule for blocking ICMP
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_icmp}

Apply blocking ICMP Firewall rule on the incoming interface
    Log    Apply blocking ICMP Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-icmp    ${APPLY_RULE_CMD}

Verify ping test and validate it is failing
    Log    Verify ping test and validate it is failing
    ${cmd}    Catenate    ping -c2     ${R1_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    100%

Remove blk-icmp firewall rule on the interface
    Log    Remove blk-icmp firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-icmp    ${APPLY_RULE_CMD}

Create Firewall rule to Allow ICMP
    Log    Create Firewall rule to Allow ICMP
    danos_cli.config    ${R2}   ${user}    ${pa}    ${allow_icmp}

Apply Allow ICMP Firewall rule on the incoming interface
    Log    Apply Allow ICMP Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    allow-icmp    ${APPLY_RULE_CMD}

Verify ping test and validate it is Passed
    Log    Verify ping test and validate it is Passed
    ${cmd}    Catenate    ping -c2     ${R1_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    100%

Remove allow-icmp firewall rule on the interface
    Log    Remove allow-icmp firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    allow-icmp    ${APPLY_RULE_CMD}

Create Firewall rule for blocking TELNET
    Log    Create Firewall rule for blocking TELNET
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_telnet}

Apply blocking TELNET Firewall rule on the incoming interface
    Log    Apply blocking TELNET Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-telnet    ${APPLY_RULE_CMD}

Verify TELNET test and validate it is failing
    Log    Verify TELNET test and validate it is failing
    ${cmd}    Catenate    telnet     ${R1_e2e_pingcheck_ip}
    Open Connection   ${R1}    prompt=$    alias=${R1}    timeout=180
    Login   ${user}    ${pa}
    Write    ${cmd}
    ${o}    Read Until    $
    Close Connection
    ${o2}    Split String    ${o}    "\n"
    Log    ${o2}
    Should Contain    ${o}    Unable to connect to remote host

Remove blk-telnet firewall rule on the interface
    Log    Remove blk-telnet firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-telnet    ${APPLY_RULE_CMD}

Create Firewall rule for allowing TELNET
    Log    Create Firewall rule for allowing TELNET
    danos_cli.config    ${R2}   ${user}    ${pa}    ${allow_telnet}

Apply allowing TELNET Firewall rule on the incoming interface
    Log    Apply allowing TELNET Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    allow-telnet    ${APPLY_RULE_CMD}

Verify TELNET test and validate it is pass
    Log    Verify TELNET test and validate it is pass
    ${cmd}    Catenate    telnet     ${R1_e2e_pingcheck_ip}
    Open Connection   ${R1}    prompt=$    alias=${R1}    timeout=180
    Login   ${user}    ${pa}
    Write    ${cmd}
    ${o}    Read Until    login:
    Close Connection
    ${o2}    Split String    ${o}    "\n"
    Log    ${o2}
    Should Contain    ${o}    Connected to

Remove allow-telnet firewall rule on the interface
    Log    Remove allow-telnet firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    allow-telnet    ${APPLY_RULE_CMD}

Create Firewall rule for blocking SSH
    Log    Create Firewall rule for blocking SSH
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_ssh}

Apply blocking SSH Firewall rule on the incoming interface
    Log    Apply blocking SSH Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-ssh    ${APPLY_RULE_CMD}

Verify SSH test and validate it is failing
    Log    Verify SSH test and validate it is failing
    ${cmd}    Catenate    ssh     ${R1_e2e_pingcheck_ip}
    Open Connection   ${R1}    prompt=$    alias=${R1}    timeout=180
    Login   ${user}    ${pa}
    Write    ${cmd}
    ${o}    Read Until    $
    Close Connection
    ${o2}    Split String    ${o}    "\n"
    Log    ${o2}
    Should Contain    ${o}    Connection timed out

Remove blk-SSH firewall rule on the interface
    Log    Remove blk-ssh firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-ssh    ${APPLY_RULE_CMD}

Create Firewall rule for allowing SSH
    Log    Create Firewall rule for allowing SSH
    danos_cli.config    ${R2}   ${user}    ${pa}    ${allow_ssh}

Apply allowing SSH Firewall rule on the incoming interface
    Log    Apply allowing SSH Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    allow-ssh    ${APPLY_RULE_CMD}

Verify SSH test and validate it is pass
    Log    Verify SSH test and validate it is pass
    ${cmd}    Catenate    ssh    ${R1_e2e_pingcheck_ip}
    Open Connection   ${R1}    prompt=$    alias=${R1}    timeout=180
    Login   ${user}    ${pa}
    Write    ${cmd}
    ${o}    Read    delay=0.5s
    #${o}    Read Until    password:
    Close Connection
    ${o2}    Split String    ${o}    "\n"
    Log    ${o2}
    Should Contain Any    ${o}    password    connecting
    #Should Contain    ${o}    Welcome to

Remove allow-ssh firewall rule on the interface
    Log    Remove allow-ssh firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    allow-ssh    ${APPLY_RULE_CMD}

Create Firewall rule for blocking TFTP
    Log    Create Firewall rule for blocking TFTP
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_tftp}

Apply blocking TFTP Firewall rule on the incoming interface
    Log    Apply blocking TFTP Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-tftp    ${APPLY_RULE_CMD}

Verify TFTP test and validate it is failing
    Log    Verify TFTP test and validate it is failing
    ${cmd}    Catenate    ssh     ${R1_e2e_pingcheck_ip}
    Open Connection   ${R1}    prompt=$    alias=${R1}    timeout=180
    Login   ${user}    ${pa}
    Write    ${cmd}
    ${o}    Read Until    $
    Close Connection
    ${o2}    Split String    ${o}    "\n"
    Log    ${o2}
    Should Contain    ${o}    Connection timed out

Remove blk-TFTP firewall rule on the interface
    Log    Remove blk-tftp firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-tftp    ${APPLY_RULE_CMD}

Create Firewall rule for allowing TFTP
    Log    Create Firewall rule for allowing TFTP
    danos_cli.config    ${R2}   ${user}    ${pa}    ${allow_tftp}

Apply allowing TFTP Firewall rule on the incoming interface
    Log    Apply allowing TFTP Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    allow-tftp    ${APPLY_RULE_CMD}

Verify TFTP test and validate it is pass
    Log    Verify TFTP test and validate it is pass
    ${cmd}    Catenate    tftp    ${R1_e2e_pingcheck_ip}
    Open Connection   ${R1}    prompt=$    alias=${R1}    timeout=30
    Login   ${user}    ${pa}
    Write    ${cmd}
    ${o}    Read Until    password:
    Close Connection
    ${o2}    Split String    ${o}    "\n"
    Log    ${o2}
    Should Contain    ${o}    Welcome to

Remove allow-tftp firewall rule on the interface
    Log    Remove allow-tftp firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    allow-tftp    ${APPLY_RULE_CMD}

Create Firewall rule to block ICMP from a specific source IP
    Log    Create Firewall rule to block ICMP from a specific source IP
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_icmp_from_ip}

Apply blocking ICMP Firewall rule on the outgoing interface
    Log    Apply blocking ICMP Firewall rule on the outgoing interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s10    blk-icmp-from-ip    ${APPLY_RULE_CMD_OUT}

Verify ping test from the source device whose IP is used in the above firewall rule and test should fail
    Log    Verify ping test from the source device whose IP is used in the above firewall rule and test should fail
    ${cmd}    Catenate    ping -c2     ${R1_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    100%

Verify ping test from other device and test should pass
    Log    Verify ping test from other device and test should pass
    ${cmd}    Catenate    ping -c2     ${R1_e2e_pingcheck_ip}
    ${output}    danos_cli.config_show    ${R2}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    100%

Remove blk-icmp-from-ip firewall rule on the interface
    Log    Remove blk-icmp-from-ip firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s10    blk-icmp-from-ip    ${APPLY_RULE_CMD_OUT}

Create Firewall rule for blocking SMTP
    Log    Create Firewall rule for blocking SMTP
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_smtp}

Apply blocking SMTP Firewall rule on the incoming interface
    Log    Apply blocking SMTP Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-smtp    ${APPLY_RULE_CMD}

Verify SMTP is blocked
    Log    Verify SMTP is blocked
    ${cmd}    Catenate    sudo nc -vz -w 1    ${R1_e2e_pingcheck_ip}    25
    ${output}    danos_cli.config_show    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    (smtp) : Connection timed out

Remove blk-smtp firewall rule on the interface
    Log    Remove blk-smtp firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-smtp    ${APPLY_RULE_CMD}

Create Firewall rule for blocking DNS
    Log    Create Firewall rule for blocking DNS
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_dns}

Apply blocking DNS Firewall rule on the incoming interface
    Log    Apply blocking DNS Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-dns    ${APPLY_RULE_CMD}

Verify DNS is blocked
    Log    Verify DNS is blocked
    ${cmd}    Catenate    sudo nc -vz -w 1    ${R1_e2e_pingcheck_ip}    53
    ${output}    danos_cli.config_show    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    (domain) : Connection timed out

Remove blk-dns firewall rule on the interface
    Log    Remove blk-dns firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-dns    ${APPLY_RULE_CMD}

Create Firewall rule for blocking HTTPS
    Log    Create Firewall rule for blocking HTTPS
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_https}

Apply blocking HTTPS Firewall rule on the incoming interface
    Log    Apply blocking HTTPS Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-https    ${APPLY_RULE_CMD}

Verify HTTPS is blocked
    Log    Verify HTTPS is blocked
    ${cmd}    Catenate    sudo nc -vz -w 1    ${R1_e2e_pingcheck_ip}    443
    ${output}    danos_cli.config_show    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    (https) : Connection timed out

Remove blk-https firewall rule on the interface
    Log    Remove blk-https firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-https    ${APPLY_RULE_CMD}

Create Firewall rule for blocking HTTP
    Log    Create Firewall rule for blocking HTTP
    danos_cli.config    ${R2}   ${user}    ${pa}    ${blk_http}

Apply blocking HTTP Firewall rule on the incoming interface
    Log    Apply blocking HTTP Firewall rule on the incoming interface
    danos_cli.apply_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-http    ${APPLY_RULE_CMD}

Verify HTTP is blocked
    Log    Verify HTTP is blocked
    ${cmd}    Catenate    sudo nc -vz -w 1    ${R1_e2e_pingcheck_ip}    80
    ${output}    danos_cli.config_show    ${R1}   ${user}    ${pa}    ${cmd}
    danos_cli.pr    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    (http) : Connection timed out

Remove blk-http firewall rule on the interface
    Log    Remove blk-http firewall rule on the interface
    danos_cli.delete_rule    ${R2}   ${user}    ${pa}    dp0s9    blk-http    ${APPLY_RULE_CMD}
