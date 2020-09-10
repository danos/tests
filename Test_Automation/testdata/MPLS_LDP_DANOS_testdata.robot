# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Variables ***
# Test data file for MPLS-LDP test topology
#Topology:-
#            lo:1.1.1.1            lo:2.2.2.2              lo:3.3.3.3
#             +----+   20.1.1.0/24  +----+   30.1.1.0/24   +----+
# Head Office | PE1|----------------| P1 |-----------------| PE2| Branch Office
#             +----+ dp0s9    dp0s3 +----+ dp0s8     dp0s8 +----+
#         dp0s3 /                                             \ dp0s3
#              /                                               \
#             / 10.1.1.0/24                                     \  172.16.1.0/24
#            /                                                   \
#         +------+                                              +------+
#         | LAN1 |                                              | LAN2 |
#         +------+                                              +------+
#
# Note: Once the topology is created, update this test data file with the values for management IP addresses,
#       network IP address, interface names details, username / passwd of danos router under below section


#---------------START----------------------------------------

${PE1}                          192.168.203.155  # PE1 Management IP
${P1}                           192.168.203.156  # P1 Management IP
${PE2}                          192.168.203.157  # PE2 Management IP
${PE1H1network}                 10.1.1.0
${PE1P1network}                 20.1.1.0
${P1PE2network}                 30.1.1.0
${PE2H2network}                 172.16.1.0
${PE1ID}                        1.1.1.1
${P1ID}                         2.2.2.2
${PE2ID}                        3.3.3.3
${PE1H1interface}               dp0s3
${PE1P1interface}               dp0s9
${P1PE1interface}               dp0s3
${P1PE2interface}               dp0s8
${PE2P1interface}               dp0s8
${PE2H2interface}               dp0s3
${PE1H1interfaceIP}             10.1.1.2
${PE1P1interfaceIP}             20.1.1.3
${P1PE1interfaceIP}             20.1.1.4
${P1PE2interfaceIP}             30.1.1.4
${PE2P1interfaceIP}             30.1.1.3
${PE2H2interfaceIP}             172.16.1.2
${user}                         vyatta
${pa}                           vyatta
#---------------END------------------------------------------

# DO NOT MODIFY BELOW THIS LINE
${validate_ospf_status}=                run show protocols ospf neighbor
@{PE1_pingcheck}=                       ${P1PE1interfaceIP}    ${P1PE2interfaceIP}    ${PE2P1interfaceIP}
@{P1_pingcheck}=                        ${PE1P1interfaceIP}    ${PE2P1interfaceIP}
@{PE2_pingcheck}=                       ${P1PE2interfaceIP}    ${P1PE1interfaceIP}    ${PE1P1interfaceIP}
${PE1_e2e_pingcheck_ip}=                ${PE2H2interfaceIP}
${PE2_e2e_pingcheck_ip}=                ${PE1H1interfaceIP}
${validate_mpls_ldp_neighbor}=          run show protocols mpls-ldp neighbor
${validate_mpls_ldp_ipv4_interface}=    run show protocols mpls-ldp ipv4 interface
${validate_mpls_ldp_ipv4_discovery}=    run show protocols mpls-ldp ipv4 discovery
${validate_mpls_ldp_ipv4_binding}=      run show protocols mpls-ldp ipv4 binding

@{PE1_interface_config}=
...    interfaces loopback lo address ${PE1ID}/32
...    interfaces dataplane ${PE1P1interface} address ${PE1P1interfaceIP}/24
...    interfaces dataplane ${PE1H1interface} address ${PE1H1interfaceIP}/24

@{PE1_ospf_protocol_config}=
...    protocols ospf area 0 network ${PE1ID}/32
...    protocols ospf area 0 network ${PE1H1network}/24
...    protocols ospf area 0 network ${PE1P1network}/24

@{PE1_mpls_ldp_config}=
...    protocols mpls-ldp address-family ipv4 discovery interface interface ${PE1P1interface}
...    protocols mpls-ldp address-family ipv4 label-policy allocate host-routes
...    protocols mpls-ldp address-family ipv4 transport-address ${PE1ID}
...    protocols mpls-ldp lsr-id ${PE1ID}

@{P1_interface_config}=
...    interfaces loopback lo address ${P1ID}/32
...    interfaces dataplane ${P1PE1interface} address ${P1PE1interfaceIP}/24
...    interfaces dataplane ${P1PE2interface} address ${P1PE2interfaceIP}/24

@{P1_ospf_protocol_config}=
...    protocols ospf area 0 network ${P1ID}/32
...    protocols ospf area 0 network ${PE1P1network}/24
...    protocols ospf area 0 network ${P1PE2network}/24

@{P1_mpls_ldp_config}=
...    protocols mpls-ldp address-family ipv4 discovery interface interface ${P1PE1interface}
...    protocols mpls-ldp address-family ipv4 discovery interface interface ${P1PE2interface}
...    protocols mpls-ldp address-family ipv4 label-policy allocate host-routes
...    protocols mpls-ldp address-family ipv4 transport-address ${P1ID}
...    protocols mpls-ldp lsr-id ${P1ID}

@{PE2_interface_config}=
...    interfaces loopback lo address ${PE2ID}/32
...    interfaces dataplane ${PE2P1interface} address ${PE2P1interfaceIP}/24
...    interfaces dataplane ${PE2H2interface} address ${PE2H2interfaceIP}/24

@{PE2_ospf_protocol_config}=
...    protocols ospf area 0 network ${PE2ID}/32
...    protocols ospf area 0 network ${P1PE2network}/24
...    protocols ospf area 0 network ${PE2H2network}/24

@{PE2_mpls_ldp_config}=
...    protocols mpls-ldp address-family ipv4 discovery interface interface ${PE2P1interface}
...    protocols mpls-ldp address-family ipv4 label-policy allocate host-routes
...    protocols mpls-ldp address-family ipv4 transport-address ${PE2ID}
...    protocols mpls-ldp lsr-id ${PE2ID}
