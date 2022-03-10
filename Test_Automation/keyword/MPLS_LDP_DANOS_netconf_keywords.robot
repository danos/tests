# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Settings ***
Variables         ../variable/danos_netconf_templates.py
Variables         ../testdata/MPLS_LDP_netconf_data.py
Library           SSHLibrary
Library           String
Library           Collections
Library           ../library/danos_netconf.py

*** Keywords ***
Configure PE1 interfaces
    Log    Configure PE1 interfaces
    ${out1}=    danos_netconf.config_interfaces    ${PE1}   ${user}    ${pa}    ${PE1_dataplane_config}    ${CONFIGURE_DATAPLANE}
    danos_netconf.print_output    ${out1}
    ${out2}=    danos_netconf.config_interfaces    ${PE1}   ${user}    ${pa}    ${PE1_loopback_config}    ${CONFIGURE_LOOPBACK}
    danos_netconf.print_output    ${out1}
    danos_netconf.print_output    ${out2}

Configure P1 interfaces
    Log    Configure P1 interfaces
    ${out1}=    danos_netconf.config_interfaces    ${P1}   ${user}    ${pa}    ${P1_dataplane_config}    ${CONFIGURE_DATAPLANE}
    danos_netconf.print_output    ${out1}
    ${out2}=    danos_netconf.config_interfaces    ${P1}   ${user}    ${pa}    ${P1_loopback_config}    ${CONFIGURE_LOOPBACK}
    danos_netconf.print_output    ${out1}
    danos_netconf.print_output    ${out2}

Configure PE2 interfaces
    Log    Configure PE2 interfaces using netconf
    ${out1}=    danos_netconf.config_interfaces    ${PE2}   ${user}    ${pa}    ${PE2_dataplane_config}    ${CONFIGURE_DATAPLANE}
    danos_netconf.print_output    ${out1}
    ${out2}=    danos_netconf.config_interfaces    ${PE2}   ${user}    ${pa}    ${PE2_loopback_config}    ${CONFIGURE_LOOPBACK}
    danos_netconf.print_output    ${out1}
    danos_netconf.print_output    ${out2}

Configure routing protocol on PE1
    Log    Configure OSPF on PE1
    ${out1}=    danos_netconf.config_ospf    ${PE1}   ${user}    ${pa}    ${PE1_ospf_config}    ${CONFIGURE_OSPF}
    danos_netconf.print_output    ${out1}

Configure routing protocol on P1
    Log    Configure OSPF on P1
    ${out1}=    danos_netconf.config_ospf    ${P1}   ${user}    ${pa}    ${P1_ospf_config}    ${CONFIGURE_OSPF}
    danos_netconf.print_output    ${out1}

Configure routing protocol on PE2
    Log    Configure OSPF on PE2
    ${out1}=    danos_netconf.config_ospf    ${PE2}   ${user}    ${pa}    ${PE2_ospf_config}    ${CONFIGURE_OSPF}
    danos_netconf.print_output    ${out1}

Configure MPLS LDP on PE1
    Log    Configure MPLS LDP on PE1
    ${out1}=    danos_netconf.config_mpls_ldp_addr_family_edge     ${PE1}   ${user}    ${pa}    ${PE1_mpls_config}    ${CONFIGURE_MPLS_LDP_AD_FAMILY_EDGE}
    danos_netconf.print_output    ${out1}

Configure MPLS LDP on P1
    Log    Configure MPLS LDP on P1
     ${out1}=    danos_netconf.config_mpls_ldp_addr_family_core     ${P1}   ${user}    ${pa}    ${P1_mpls_config}    ${CONFIGURE_MPLS_LDP_AD_FAMILY_CORE}
    danos_netconf.print_output    ${out1}

Configure MPLS LDP on PE2
    Log    Configure MPLS LDP on PE2
    ${out1}=    danos_netconf.config_mpls_ldp_addr_family_edge     ${PE2}   ${user}    ${pa}    ${PE2_mpls_config}    ${CONFIGURE_MPLS_LDP_AD_FAMILY_EDGE}
    danos_netconf.print_output    ${out1}

Verify connectivity from PE1
    Log   Performing PING test using Netconf from host ${PE1}
    FOR  ${ip}  IN    @{PE1_pingcheck}
        ${output}=    danos_netconf.ping    ${PE1}    ${user}    ${pa}    ${ip}    4    ${PINGD}
        danos_netconf.print_output    ${output}
        ${o}    Evaluate    ''.join(${output})
        Should Contain    ${o}    rx-packet-count
    END

Verify connectivity from P1
    Log   Performing PING test using Netconf from host ${P1}
    FOR  ${ip}  IN    @{P1_pingcheck}
        ${output}=    danos_netconf.ping    ${P1}    ${user}    ${pa}    ${ip}    4    ${PINGD}
        danos_netconf.print_output    ${output}
        ${o}    Evaluate    ''.join(${output})
        Should Contain    ${o}    rx-packet-count
    END

Verify connectivity from PE2
    FOR  ${ip}  IN    @{PE2_pingcheck}
        ${output}=    danos_netconf.ping    ${PE2}    ${user}    ${pa}    ${ip}    4    ${PINGD}
        danos_netconf.print_output    ${output}
        ${o}    Evaluate    ''.join(${output})
        Should Contain    ${o}    rx-packet-count
    END

Verify E2E reachability from PE1
    Log    Verify E2E reachability from PE1
    ${output}=    danos_netconf.ping    ${PE1}    ${user}    ${pa}    ${PE1_e2e_pingcheck_ip}    4    ${PINGD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    rx-packet-count

Verify E2E reachability from PE2
    Log    Verify E2E reachability from PE2
    ${output}=    danos_netconf.ping    ${PE2}    ${user}    ${pa}    ${PE2_e2e_pingcheck_ip}    4    ${PINGD}
    danos_netconf.print_output   ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    rx-packet-count

Validate OSPF status on PE1
    Log    Validate OSPF status on PE1 netconf
    ${output}    danos_netconf.show_cmd    ${PE1}   ${user}    ${pa}    ${validate_ospf_status}    ${SHOW_CMD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    Full

Validate OSPF status on PE2
    Log    Validate OSPF status on PE2 netconf
    ${output}    danos_netconf.show_cmd    ${PE2}   ${user}    ${pa}    ${validate_ospf_status}    ${SHOW_CMD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    Full

Validate MPLS-LDP Neighbor status
   FOR  ${ip}  IN    ${PE1}    ${P1}    ${PE2}
       Log    Validate MPLS-LDP Neighbor status on ${ip}
       ${output}    danos_netconf.show_cmd    ${ip}   ${user}    ${pa}    ${validate_mpls_ldp_neighbor}    ${SHOW_CMD}
       danos_netconf.print_output    ${output}
       ${o}    Evaluate    ''.join(${output})
       Should Contain    ${o}    OPERATIONAL
   END

Validate MPLS-LDP IPv4 interface status
    FOR  ${ip}  IN    ${PE1}    ${P1}    ${PE2}
        Log    Validate MPLS-LDP IPv4 interface status on ${ip}
        ${output}    danos_netconf.show_cmd    ${ip}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_interface}    ${SHOW_CMD}
        danos_netconf.print_output    ${output}
        ${o}    Evaluate    ''.join(${output})
        Should Contain    ${o}    ACTIVE
    END

Validate MPLS-LDP IPv4 discovery status on PE1
    Log    Validate MPLS-LDP IPv4 discovery status on PE1
    ${output}    danos_netconf.show_cmd    ${PE1}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_discovery}    ${SHOW_CMD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${P1_router_id}
    Should Not Contain    ${o}    ${PE2_router_id}
    Should Not Contain    ${o}    ${PE1_router_id}

Validate MPLS-LDP IPv4 discovery status on P1
    Log    Validate MPLS-LDP IPv4 discovery status on P1
    ${output}    danos_netconf.show_cmd    ${P1}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_discovery}    ${SHOW_CMD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${PE1_router_id}
    Should Contain    ${o}    ${PE2_router_id}
    Should Not Contain    ${o}    ${P1_router_id}

Validate MPLS-LDP IPv4 discovery status on PE2
    Log    Validate MPLS-LDP IPv4 discovery status on PE2
    ${output}    danos_netconf.show_cmd    ${PE2}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_discovery}    ${SHOW_CMD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Not Contain    ${o}    ${PE1_router_id}
    Should Contain    ${o}    ${P1_router_id}
    Should Not Contain    ${o}    ${PE2_router_id}

Validate MPLS-LDP IPv4 binding status on PE1
    Log    Validate MPLS-LDP IPv4 binding status on PE1
    ${output}    danos_netconf.show_cmd    ${PE1}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_binding}    ${SHOW_CMD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${PE1_binding_chk}

Validate MPLS-LDP IPv4 binding status on P1
    Log    Validate MPLS-LDP IPv4 binding status on P1
    ${output}    danos_netconf.show_cmd    ${P1}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_binding}    ${SHOW_CMD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${P1_binding_chk1}
    Should Contain    ${o}    ${P1_binding_chk2}

Validate MPLS-LDP IPv4 binding status on PE2
    Log    Validate MPLS-LDP IPv4 binding status on PE2
    ${output}    danos_netconf.show_cmd    ${PE2}   ${user}    ${pa}    ${validate_mpls_ldp_ipv4_binding}    ${SHOW_CMD}
    danos_netconf.print_output    ${output}
    ${o}    Evaluate    ''.join(${output})
    Should Contain    ${o}    ${PE2_binding_chk}

Clear configurations on the topology
    Log    Clear all config
    FOR  ${ip}   IN    ${PE1}    ${P1}    ${PE2}
         ${out1}    danos_netconf.del_cmd    ${ip}   ${user}    ${pa}    ${DELETE_MPLS}    ${DELETE_OSPF}    ${DELETE_INTERFACES_DATAPLANE}  ${DELETE_LOOPBACK}
        danos_netconf.print_output    ${out1}
    END

Clear netconf configurations
    :FOR  ${vm}  IN    @{hosts}
    \    Log    Clear configurations on ${vm}
    \    ${id}    Open Connection   ${vm}    prompt=$    alias=${vm}    timeout=35
    \    Login   ${user}    ${pa}
    \    Write    configure
    \    ${o}    Read Until    \#
    \    Write    delete service netconf
    \    ${o}    Read Until    \#
    \    Write    set service netconf
    \    ${o}    Read Until    \#
    \    Write    commit
    \    ${o}    Read Until    \#
    \    Close All Connections
