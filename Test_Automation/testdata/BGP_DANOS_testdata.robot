# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
*** Settings ***

*** Variables ***
# Test data file for IBGP test scenarios
#Topology:-
#                             dp0s9  +-----+ dp0s3
#                       +------------+  R4 +-------------+
#                      /             +--+--+              \
#        205.1.1.0/24 /                 | dp0s10           \
#                    /                  |                   \ 204.1.1.0/24
#                   /       203.1.1.0/24|                    \
#                  /                    |                     \
#           dp0s9 /                     |  dp0s10              \ dp0s3
#             +--+--+  201.1.1.0/24  +--+--+  202.1.1.0/24   +--+--+
#             |  R1 +----------------+  R2 +-----------------+  R3 |
#             +--+--+ dp0s3    dp0s3 +-----+ dp0s9     dp0s9 +--+--+
#         dp0sX /   <======EBGP======>     <=======IBGP======>   \ dp0sX
#              /                                                  \
#             / 10.1.1.0/24                            13.1.1.0/24 \
#            /                                                      \
#        +--+---+                                                +---+--+
#        | LAN1 |                                                | LAN2 |
#        +------+                                                +------+
#
# Note: Once the topology is created, update this test data file with the values for management IP addresses,
#       network IP address, interface names details, username / passwd of danos router under below section

#---------------START----------------------------------------
${R1}                             192.168.203.158
${R2}                             192.168.203.159
${R3}                             192.168.203.160
${R4}                             192.168.203.206
${user}                           vyatta
${pa}                             vyatta

${R1LAN1_interface}               dp0sX
${R1R2_interface}                 dp0s3
${R1R4_interface}                 dp0s9
${R2R1_interface}                 dp0s3
${R2R3_interface}                 dp0s9
${R2R4_interface}                 dp0s10
${R3R2_interface}                 dp0s9
${R3LAN2_interface}               dp0sX
${R3R4_interface}                 dp0s3
${R4R2_interface}                 dp0s10
${R4R3_interface}                 dp0s3
${R4R1_interface}                 dp0s9

${R1LAN1_iface_ip}                10.1.1.3
${R1R2_iface_ip}                  201.1.1.3
${R2R1_iface_ip}                  201.1.1.4
${R2R3_iface_ip}                  202.1.1.3
${R3R2_iface_ip}                  202.1.1.4
${R2R4_iface_ip}                  203.1.1.3
${R4R2_iface_ip}                  203.1.1.4
${R3R4_iface_ip}                  204.1.1.3
${R4R3_iface_ip}                  204.1.1.4
${R1R4_iface_ip}                  205.1.1.3
${R4R1_iface_ip}                  205.1.1.4
${R3LAN2_iface_ip}                13.1.1.3

${R1R2_nw}                        201.1.1.0
${R2R3_nw}                        202.1.1.0
${R2R4_nw}                        203.1.1.0
${R3R4_nw}                        204.1.1.0
${R1R4_nw}                        205.1.1.0

${R1BgpID}                        100
${R2BgpID}                        200
${R3BgpID}                        300
${R4BgpID}                        400
${R1_lb}                          lo5
${R2_lb}                          lo5
${R3_lb}                          lo5
${R4_lb}                          lo5
${lo10}                           lo10
${lo20}                           lo20
${lo30}                           lo30
${lo40}                           lo40
${lo10_ip}                        10.10.10.10
${lo20_ip}                        20.20.20.20
${lo30_ip}                        30.30.30.30
${lo40_ip}                        40.40.40.40
${R1ID}                           1.1.1.1
${R2ID}                           2.2.2.2
${R3ID}                           3.3.3.3
${R4ID}                           4.4.4.4
${R1_BGP_AS}                      1
${R2_BGP_AS}                      1
${R3_BGP_AS}                      1
${R4_BGP_AS}                      1
${EBGP_AS}                        2
${R1_EBGP_AS}                     100
${R2_EBGP_AS}                     200
${R3_EBGP_AS}                     300
${R1_rr_ip}                       50.50.50.50
${ospf_area}                      0
#---------------END------------------------------------------
${show_bgp_neighbor}              show protocols bgp all summary
${show_ospf_neighbor}             show protocols ospf neighbor
${show_bgp_ipv4_unicast}          show protocols bgp ipv4 unicast
${show_bgp_ipv4_unicast_ip}       ${show_bgp_ipv4_unicast} ${R1_rr_ip}

@{access}=
...    touch .hushlogin
...    show version

@{delete_config}=
...    interfaces
...    security vpn ipsec
...    protocols ospf
...    protocols bgp

@{R1_interface_config}=
...    interfaces loopback ${R1_lb} address ${R1ID}/32
...    interfaces dataplane ${R1R2_interface} address ${R1R2_iface_ip}/24

@{R1_protocol_config}=
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} remote-as ${R1_BGP_AS}
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} address-family ipv4-unicast

@{R2_interface_config}=
...    interfaces loopback ${R2_lb} address ${R2ID}/32
...    interfaces dataplane ${R2R1_interface} address ${R2R1_iface_ip}/24
...    interfaces dataplane ${R2R3_interface} address ${R2R3_iface_ip}/24
...    interfaces dataplane ${R2R4_interface} address ${R2R4_iface_ip}/24

@{R2_protocol_config}=
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} address-family ipv4-unicast

@{R3_interface_config}=
...    interfaces loopback ${R3_lb} address ${R3ID}/32
...    interfaces dataplane ${R3R2_interface} address ${R3R2_iface_ip}/24

@{R3_protocol_config}=
...    protocols bgp ${R3_BGP_AS} neighbor ${R2R3_iface_ip} remote-as ${R3_BGP_AS}
...    protocols bgp ${R3_BGP_AS} neighbor ${R2R3_iface_ip} address-family ipv4-unicast

@{R4_interface_config}=
...    interfaces loopback ${R4_lb} address ${R4ID}/32
...    interfaces dataplane ${R4R2_interface} address ${R4R2_iface_ip}/24

@{R4_protocol_config}=
...    protocols bgp ${R4_BGP_AS} neighbor ${R2R4_iface_ip} remote-as ${R4_BGP_AS}
...    protocols bgp ${R4_BGP_AS} neighbor ${R2R4_iface_ip} address-family ipv4-unicast

@{R1_pingcheck}=    ${R2R1_iface_ip}    ${R2R3_iface_ip}    ${R2R4_iface_ip}    ${R3R2_iface_ip}    ${R4R2_iface_ip}
@{R2_pingcheck}=    ${R1R2_iface_ip}    ${R3R2_iface_ip}    ${R4R2_iface_ip}
@{R3_pingcheck}=    ${R2R3_iface_ip}    ${R2R1_iface_ip}    ${R2R4_iface_ip}    ${R1R2_iface_ip}    ${R4R2_iface_ip}
@{R4_pingcheck}=    ${R2R4_iface_ip}    ${R2R1_iface_ip}    ${R2R3_iface_ip}    ${R1R2_iface_ip}    ${R3R2_iface_ip}

@{R1_neighbors}=    ${R2R1_iface_ip}
@{R2_neighbors}=    ${R1R2_iface_ip}    ${R3R2_iface_ip}    ${R4R2_iface_ip}
@{R3_neighbors}=    ${R2R3_iface_ip}
@{R4_neighbors}=    ${R2R4_iface_ip}

@{R2_RR_Client_R1}=
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast route-reflector-client

@{R2_RR_Client_R3}=
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast route-reflector-client

@{R3_NRR_advertise}=
...    protocols bgp ${R3_BGP_AS} address-family ipv4-unicast network ${R3ID}/32

@{R1_NRR_advertise}=
...    protocols bgp ${R1_BGP_AS} address-family ipv4-unicast network ${R1ID}/32

@{R2_protocol_config_ebgp}=
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} remote-as ${EBGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} address-family ipv4-unicast

@{R3_protocol_config_ebgp}=
...    protocols bgp ${EBGP_AS} neighbor ${R2R3_iface_ip} remote-as ${R3_BGP_AS}
...    protocols bgp ${EBGP_AS} neighbor ${R2R3_iface_ip} address-family ipv4-unicast

@{R3_NRR_advertise_ebgp}=
...    protocols bgp ${EBGP_AS} address-family ipv4-unicast network ${R3ID}/32

@{del}=
...    protocols bgp
...    protocols static
...    protocols ospf

# RR Rule-1 configurations
@{R1_protocol_config_RR_rule_1}
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} remote-as ${R1_BGP_AS}
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} address-family ipv4-unicast

@{R2_protocol_config_RR_rule_1}=
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast route-reflector-client

@{R3_protocol_config_RR_rule_1}=
...    protocols bgp ${R3_BGP_AS} neighbor ${R2R3_iface_ip} remote-as ${R3_BGP_AS}
...    protocols bgp ${R3_BGP_AS} neighbor ${R2R3_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R3_BGP_AS} address-family ipv4-unicast network ${R3ID}/32

@{R4_protocol_config_RR_rule_1}=
...    protocols bgp ${R4_BGP_AS} neighbor ${R2R4_iface_ip} remote-as ${R4_BGP_AS}
...    protocols bgp ${R4_BGP_AS} neighbor ${R2R4_iface_ip} address-family ipv4-unicast

# Validate Next-hop attribute. This validation is done with the provious test configurations
${show_bgp_ipv4_unicast_hop}    show protocols bgp ipv4 unicast ${R3ID}

# RR Rule-2 configurations
@{R1_protocol_config_RR_rule_2}
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} remote-as ${R1_BGP_AS}
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1_BGP_AS} address-family ipv4-unicast network ${R1ID}/32

@{R2_protocol_config_RR_rule_2}=
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast route-reflector-client
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast route-reflector-client

@{R3_protocol_config_RR_rule_2}=
...    protocols bgp ${R3_BGP_AS} neighbor ${R2R3_iface_ip} remote-as ${R3_BGP_AS}
...    protocols bgp ${R3_BGP_AS} neighbor ${R2R3_iface_ip} address-family ipv4-unicast

@{R4_protocol_config_RR_rule_2}=
...    protocols bgp ${R4_BGP_AS} neighbor ${R2R4_iface_ip} remote-as ${R4_BGP_AS}
...    protocols bgp ${R4_BGP_AS} neighbor ${R2R4_iface_ip} address-family ipv4-unicast

# RR Rule-3 configurations
@{R1_protocol_config_RR_rule_3}
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} remote-as ${R1_BGP_AS}
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1_BGP_AS} address-family ipv4-unicast network ${R1ID}/32

@{R2_protocol_config_RR_rule_3}=
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} remote-as ${EBGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} remote-as ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R4R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast route-reflector-client

@{R3_protocol_config_RR_rule_3}=
...    protocols bgp ${EBGP_AS} neighbor ${R2R3_iface_ip} remote-as ${R3_BGP_AS}
...    protocols bgp ${EBGP_AS} neighbor ${R2R3_iface_ip} address-family ipv4-unicast
...    protocols bgp ${EBGP_AS} address-family ipv4-unicast network ${R3ID}/32

@{R4_protocol_config_RR_rule_3}=
...    protocols bgp ${R4_BGP_AS} neighbor ${R2R4_iface_ip} remote-as ${R4_BGP_AS}
...    protocols bgp ${R4_BGP_AS} neighbor ${R2R4_iface_ip} address-family ipv4-unicast

#Verify EBGP on directly connected neighbors
@{R1_protocol_config_ebgp_directconnect}=
...    protocols bgp ${R1_EBGP_AS} address-family ipv4-unicast
...    protocols bgp ${R1_EBGP_AS} neighbor ${R2R1_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1_EBGP_AS} neighbor ${R2R1_iface_ip} remote-as ${R2_EBGP_AS}

@{R2_protocol_config_ebgp_directconnect}=
...    protocols bgp ${R2_EBGP_AS} address-family ipv4-unicast
...    protocols bgp ${R2_EBGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_EBGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R1_EBGP_AS}

#Verify EBGP Neighbor with Multihop option
@{R1_protocol_config_ebgp_multihop}=
...    protocols bgp ${R1_EBGP_AS}
...    protocols bgp ${R1_EBGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1_EBGP_AS} neighbor ${R3R2_iface_ip} remote-as ${R3_EBGP_AS}
...    protocols bgp ${R1_EBGP_AS} neighbor ${R3R2_iface_ip} update-source ${R1R2_iface_ip}
...    protocols bgp ${R1_EBGP_AS} neighbor ${R3R2_iface_ip} ebgp-multihop 3
...    protocols static route ${R2R3_nw}/24 next-hop ${R2R1_iface_ip}

@{R3_protocol_config_ebgp_multihop}=
...    protocols bgp ${R3_EBGP_AS}
...    protocols bgp ${R3_EBGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R3_EBGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R1_EBGP_AS}
...    protocols bgp ${R3_EBGP_AS} neighbor ${R1R2_iface_ip} update-source ${R3R2_iface_ip}
...    protocols bgp ${R3_EBGP_AS} neighbor ${R1R2_iface_ip} ebgp-multihop 3
...    protocols static route ${R1R2_nw}/24 next-hop ${R2R3_iface_ip}

#Verify iBGP on directly connected neighbors
@{R1_protocol_config_ibgp_directconnect}=
...    protocols bgp ${R1_BGP_AS}
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1_BGP_AS} neighbor ${R2R1_iface_ip} remote-as ${R2_BGP_AS}

@{R2_protocol_config_ibgp_directconnect}=
...    protocols bgp ${R2_BGP_AS}
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2_BGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R1_BGP_AS}


#Verify iBGP Neighbor with Multihop option
@{R1_protocol_config_ibgp_multihop}=
...    protocols bgp ${R1_BGP_AS}
...    protocols bgp ${R1_BGP_AS} neighbor ${R3R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1_BGP_AS} neighbor ${R3R2_iface_ip} remote-as ${R3_BGP_AS}
...    protocols bgp ${R1_BGP_AS} neighbor ${R3R2_iface_ip} update-source ${R1R2_iface_ip}
...    protocols bgp ${R1_BGP_AS} parameters router-id ${R1ID}
...    protocols ospf parameters router-id ${R1ID}
...    protocols ospf area ${ospf_area} network ${R1ID}/32
...    protocols ospf area ${ospf_area} network ${R1R2_nw}/24

@{R2_protocol_config_ibgp_multihop}=
...    protocols ospf area ${ospf_area} network ${R2ID}/32
...    protocols ospf area ${ospf_area} network ${R1R2_nw}/24
...    protocols ospf area ${ospf_area} network ${R2R3_nw}/24

@{R3_protocol_config_ibgp_multihop}=
...    protocols bgp ${R3_BGP_AS}
...    protocols bgp ${R3_BGP_AS} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R3_BGP_AS} neighbor ${R1R2_iface_ip} remote-as ${R3_BGP_AS}
...    protocols bgp ${R3_BGP_AS} neighbor ${R1R2_iface_ip} update-source ${R3R2_iface_ip}
...    protocols bgp ${R3_BGP_AS} parameters router-id ${R3ID}
...    protocols ospf parameters router-id ${R3ID}
...    protocols ospf area ${ospf_area} network ${R3ID}/32
...    protocols ospf area ${ospf_area} network ${R2R3_nw}/24

# Validate BGP route selection between iBGP v/s eBGP
@{R1_config_best_path}=
...    interfaces dataplane ${R1R2_interface} address ${R1R2_iface_ip}/24
...    interfaces dataplane ${R1R4_interface} address ${R1R4_iface_ip}/24
...    interfaces loopback ${lo10} address ${lo10_ip}/32
...    protocols bgp ${R1BgpID} address-family ipv4-unicast
...    protocols bgp ${R1BgpID} neighbor ${R2R1_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1BgpID} neighbor ${R2R1_iface_ip} remote-as ${R2BgpID}
...    protocols bgp ${R1BgpID} neighbor ${R4R1_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1BgpID} neighbor ${R4R1_iface_ip} remote-as ${R4BgpID}


@{R1_config_best_path_new_nw}=
...    interfaces loopback ${lo10} address ${R1_rr_ip}/32
...    protocols bgp ${R1BgpID} address-family ipv4-unicast network ${R1_rr_ip}/32

@{R2_config_best_path}=
...    interfaces dataplane ${R2R3_interface} address ${R2R3_iface_ip}/24
...    interfaces dataplane ${R2R1_interface} address ${R2R1_iface_ip}/24
...    interfaces loopback ${lo20} address ${lo20_ip}/32
...    protocols ospf area ${ospf_area} network ${R2R3_nw}/24
...    protocols ospf area ${ospf_area} network ${lo20_ip}/32
...    protocols bgp ${R2BgpID} address-family ipv4-unicast
...    protocols bgp ${R2BgpID} neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2BgpID} neighbor ${R1R2_iface_ip} remote-as ${R1BgpID}
...    protocols bgp ${R2BgpID} neighbor ${lo30_ip} address-family ipv4-unicast
...    protocols bgp ${R2BgpID} neighbor ${lo30_ip} remote-as ${R2BgpID}
...    protocols bgp ${R2BgpID} neighbor ${lo30_ip} update-source ${lo20_ip}
...    protocols bgp ${R2BgpID} neighbor ${lo30_ip} nexthop-self
...    protocols bgp ${R2BgpID} address-family ipv4-unicast redistribute connected

@{R3_config_best_path}=
...    interfaces dataplane ${R3R2_interface} address ${R3R2_iface_ip}/24
...    interfaces dataplane ${R3R4_interface} address ${R3R4_iface_ip}/24
...    interfaces loopback ${lo30} address ${lo30_ip}/32
...    protocols ospf area ${ospf_area} network ${R2R3_nw}/24
...    protocols ospf area ${ospf_area} network ${lo30_ip}/32
...    protocols bgp ${R2BgpID} address-family ipv4-unicast
...    protocols bgp ${R2BgpID} neighbor ${R4R3_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R2BgpID} neighbor ${R4R3_iface_ip} remote-as ${R4BgpID}
...    protocols bgp ${R2BgpID} neighbor ${lo20_ip} address-family ipv4-unicast
...    protocols bgp ${R2BgpID} neighbor ${lo20_ip} remote-as ${R2BgpID}
...    protocols bgp ${R2BgpID} neighbor ${lo20_ip} update-source ${lo30_ip}

@{R3_config_best_path_shutdown}=
...    protocols bgp ${R2BgpID} neighbor ${R4R3_iface_ip} shutdown

@{R4_config_best_path}=
...    interfaces dataplane ${R4R3_interface} address ${R4R3_iface_ip}/24
...    interfaces dataplane ${R4R1_interface} address ${R4R1_iface_ip}/24
...    protocols bgp ${R4BgpID} address-family ipv4-unicast
...    protocols bgp ${R4BgpID} neighbor ${R1R4_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R4BgpID} neighbor ${R1R4_iface_ip} remote-as ${R1BgpID}
...    protocols bgp ${R4BgpID} neighbor ${R3R4_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R4BgpID} neighbor ${R3R4_iface_ip} remote-as ${R2BgpID}
...    protocols bgp ${R4BgpID} address-family ipv4-unicast redistribute connected

# Verify local preference
${local_pref_expected_before}    ${R1_rr_ip}/32 [${R2BgpID}/0] via ${R1R2_iface_ip}

@{apply_local_preference}=
...    protocols bgp ${R2BgpID} parameters default local-pref ${R2BgpID}

${reset_bgp}    reset protocols bgp all neighbor

${local_pref_expected_after}    ${R1_rr_ip}/32 [20/0] via ${R4R3_iface_ip}

# Validate BGP confederation
@{R1_confederation}=
...    interfaces dataplane ${R1R2_interface} address ${R1R2_iface_ip}/24
...    interfaces dataplane ${R1R4_interface} address ${R1R4_iface_ip}/24
...    protocols bgp ${R1BgpID}
...    protocols bgp ${R1BgpID} neighbor ${R2R1_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1BgpID} neighbor ${R2R1_iface_ip} remote-as ${R2BgpID}
...    protocols bgp ${R1BgpID} neighbor ${R4R1_iface_ip} address-family ipv4-unicast
...    protocols bgp ${R1BgpID} neighbor ${R4R1_iface_ip} remote-as ${R2BgpID}

@{R2_confederation}=
...    interfaces dataplane ${R2R3_interface} address ${R2R3_iface_ip}/24
...    interfaces dataplane ${R2R1_interface} address ${R2R1_iface_ip}/24
...    protocols bgp 6700
...    protocols bgp 6700 neighbor ${R1R2_iface_ip} address-family ipv4-unicast
...    protocols bgp 6700 neighbor ${R1R2_iface_ip} remote-as ${R1BgpID}
...    protocols bgp 6700 parameters confederation identifier ${R2BgpID}
...    protocols bgp 6700 neighbor ${R3R2_iface_ip} address-family ipv4-unicast
...    protocols bgp 6700 neighbor ${R3R2_iface_ip} remote-as 6600
...    protocols bgp 6700 parameters confederation peers 6600

@{R3_confederation}=
...    interfaces dataplane ${R3R2_interface} address ${R3R2_iface_ip}/24
...    interfaces dataplane ${R3R4_interface} address ${R3R4_iface_ip}/24
...    protocols bgp 6600
...    protocols bgp 6600 parameters confederation peers 6700
...    protocols bgp 6600 parameters confederation peers 6500
...    protocols bgp 6600 parameters confederation identifier ${R2BgpID}
...    protocols bgp 6600 neighbor ${R2R3_iface_ip} address-family ipv4-unicast
...    protocols bgp 6600 neighbor ${R2R3_iface_ip} remote-as 6700
...    protocols bgp 6600 neighbor ${R4R3_iface_ip} address-family ipv4-unicast
...    protocols bgp 6600 neighbor ${R4R3_iface_ip} remote-as 6500

@{R4_confederation}=
...    interfaces dataplane ${R4R3_interface} address ${R4R3_iface_ip}/24
...    interfaces dataplane ${R4R1_interface} address ${R4R1_iface_ip}/24
...    protocols bgp 6500
...    protocols bgp 6500 parameters confederation identifier ${R2BgpID}
...    protocols bgp 6500 parameters confederation peers 6600
...    protocols bgp 6500 neighbor ${R1R4_iface_ip} address-family ipv4-unicast
...    protocols bgp 6500 neighbor ${R1R4_iface_ip} remote-as ${R1BgpID}
...    protocols bgp 6500 neighbor ${R3R4_iface_ip} address-family ipv4-unicast
...    protocols bgp 6500 neighbor ${R3R4_iface_ip} remote-as 6600

#Verify Route Flaping/dampening Feature
@{R4_apply_route_dampening}=
...    protocols bgp 6500 address-family ipv4-unicast parameters dampening

@{R1_nw}=
...    protocols bgp ${R1BgpID} address-family ipv4-unicast network ${R1_rr_ip}/32

${route_flapping}    show protocols bgp ipv4 unicast dampening flap-statistics
