# * Copyright (c) 2021-2022, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Keywords ***
LoginToRESTClient
    Open Connection   ${RESTClient}    prompt=$    alias=${RESTClient}    timeout=15
    Login   ${u}    ${p}

LoginToDevice
    Open Connection   ${HOST1}    prompt=$    alias=${HOST1}    timeout=15
    Login   ${user}    ${pa}

Logout
    Close All Connections

ShowCommand
    [Arguments]    ${arg1}    ${arg2}
    LoginToDevice
    Switch Connection    ${arg1}
    Write    ${arg2}
    ${output}    Read Until    $
    [Return]    ${output}

deleteID
    [Arguments]    ${arg1}    ${arg2}
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    ${cmd}    Catenate    SEPARATOR=    ${arg1}    ${arg2}    
    Write    ${cmd}
    Read Until    $

Show Device Version
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${show_version}
    ${output}    Read Until    $
    ${match}    ${opID}    Should Match Regexp    ${output}    Location:\\s+rest\/op\/(.*)\\n
    ${cmd2}    Replace String Using Regexp    ${show_version}    \/rest\/op\/.*    \/rest\/op\/${opID}
    ${cmd3}    Replace String Using Regexp    ${cmd2}    POST    GET
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_op_id}    ${opID}
    Should Match Regexp    ${output}    DANOS

Show Interfaces
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${show_interfaces}
    ${output}    Read Until    $
    ${match}    ${opID}    Should Match Regexp    ${output}    Location:\\s+rest\/op\/(.*)\\n
    ${cmd2}    Replace String Using Regexp    ${show_interfaces}    \/rest\/op\/.*    \/rest\/op\/${opID}
    ${cmd3}    Replace String Using Regexp    ${cmd2}    POST    GET
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_op_id}    ${opID}
    Should Match Regexp    ${output}    dp0s
    Should Match Regexp    ${output}    A/D  auto/auto

Show Interface Counters
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${show_interface_counters}
    ${output}    Read Until    $
    ${match}    ${opID}    Should Match Regexp    ${output}    Location:\\s+rest\/op\/(.*)\\n
    ${cmd2}    Replace String Using Regexp    ${show_interface_counters}    \/rest\/op\/.*    \/rest\/op\/${opID}
    ${cmd3}    Replace String Using Regexp    ${cmd2}    POST    GET
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_op_id}    ${opID}
    Should Match Regexp    ${output}    Rx Packets

Set Interface IP
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${set_interface_ip_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${set_interface_ip_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${set_interface_ip_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Presense of IP Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_iface}
    Should Match Regexp    ${output}    ${R1LAN1_iface_ip}

Delete Interface IP
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${del_interface_ip_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${del_interface_ip_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${del_interface_ip_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Deletion of IP Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_iface}
    Should Not Match Regexp    ${output}    ${R1LAN1_iface_ip}

Set BGP Protocol
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${set_bgp_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${set_bgp_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${set_bgp_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Presense of BGP Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_bgp}
    Should Match Regexp    ${output}    bgp 22

Delete BGP Protocol
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${del_bgp_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${del_bgp_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${del_bgp_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Deletion of BGP Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_bgp}
    Should Not Match Regexp    ${output}    bgp 22

Set OSPF Protocol
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${set_ospf_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${set_ospf_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${set_ospf_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Presense of OSPF Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_ospf}
    Should Match Regexp    ${output}    ospf

Delete OSPF Protocol
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${del_ospf_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${del_ospf_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${del_ospf_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Deletion of OSPF Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_ospf}
    Should Not Match Regexp    ${output}    ospf

Set ISIS Protocol
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${set_isis_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${set_isis_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${set_isis_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Presense of ISIS Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_isis}
    Should Match Regexp    ${output}    isis

Delete ISIS Protocol
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${del_isis_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${del_isis_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${del_isis_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Deletion of ISIS Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_isis}
    Should Not Match Regexp    ${output}    isis

Set Security Firewall
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${set_firewall_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${set_firewall_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${set_firewall_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Presense of Security Firewall Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_firewall}
    Should Match Regexp    ${output}    fwtest

Delete Security Firewall
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${del_firewall_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${del_firewall_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${del_firewall_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Deletion of Security Firewall Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_firewall}
    Should Not Match Regexp    ${output}    fwtest

Set DNS Configuration
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${set_dns_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${set_dns_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${set_dns_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Presense of DNS Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_dns}
    Should Match Regexp    ${output}    dns

Delete DNS Configuration
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${del_dns_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${del_dns_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${del_dns_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Deletion of DNS Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_dns}
    Should Not Match Regexp    ${output}    dns

Set NTP Configuration
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${set_ntp_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${set_ntp_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${set_ntp_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Presense of NTP Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_ntp}
    Should Match Regexp    ${output}    ntp

Delete NTP Configuration
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${del_ntp_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${del_ntp_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${del_ntp_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Deletion of NTP Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_ntp}
    Should Not Match Regexp    ${output}    ntp

Set NAT Configuration
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${set_nat_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${set_nat_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${set_nat_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Presense of NAT Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_nat}
    Should Match Regexp    ${output}    nat

Delete NAT Configuration
    LoginToRESTClient
    Switch Connection    ${RESTClient}
    Write    ${del_nat_post}
    ${output}    Read Until    $
    ${match}    ${confID}    Should Match Regexp    ${output}    Location:\\s+rest\/conf\/(.*)\\n
    ${confID}    Replace String Using Regexp    ${confID}    \r    ${EMPTY}
    ${cmd2}    Replace String Using Regexp    ${del_nat_put}    CONFID    ${confID}
    Write    ${cmd2}
    ${output}    Read Until    $
    ${cmd3}    Replace String Using Regexp    ${del_nat_commit}    CONFID    ${confID}
    Write    ${cmd3}
    ${output}    Read Until    $
    DeleteID    ${delete_conf_id}    ${confID}

Validate Deletion of NAT Configuration via CLI
    ${output}    ShowCommand    ${HOST1}    ${show_nat}
    Should Not Match Regexp    ${output}    nat

Prerequisite checks
    LoginToDevice
    Switch Connection    ${HOST1}
    Write    configure
    Read Until    \#
    Write    set service https
    Read Until    \#
    Write    delete protocols
    Read Until    \#
    Write    delete security
    Read Until    \#
    Write    delete system ntp
    Read Until    \#
    Write    delete service dns
    Read Until    \#
    Write    delete service nat
    Read Until    \#
    Write    delete interfaces dataplane
    Read Until    \#
    Write    commit
    Read Until    \#
    Write    exit
    Read Until    $
