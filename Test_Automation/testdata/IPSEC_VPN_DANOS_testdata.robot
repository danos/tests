# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
#*** Settings ***
#Library    Collections

*** Variables ***
# Test data file for IPSec VPN test topology
#Topology:-
#             +----+  140.1.1.0/24  +----+  150.1.1.0/24   +----+
# Head Office | R1 |----------------| R2 |-----------------| R3 | Branch Office
#             +----+ dp0s9    dp0s3 +----+ dp0s8     dp0s8 +----+
#         dp0s3 /    <=========== IPSEC Tunnel ==========>    \ dp0s3
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
${R1}                           192.168.203.155  # R1 Management IP
${R2}                           192.168.203.156  # R2 Management IP
${R3}                           192.168.203.157  # R3 Management IP
${R1H1network}                  10.1.1.0
${R1R2network}                  140.1.1.0
${R2R3network}                  150.1.1.0
${R3H2network}                  172.16.1.0
${R1ID}                         1.1.1.1
${R2ID}                         2.2.2.2
${R3ID}                         3.3.3.3
${R1H1interface}                dp0s3
${R1R2interface}                dp0s9
${R2R1interface}                dp0s3
${R2R3interface}                dp0s8
${R3R2interface}                dp0s8
${R3H2interface}                dp0s3
${R1H1interfaceIP}              10.1.1.2
${R1R2interfaceIP}              140.1.1.3
${R2R1interfaceIP}              140.1.1.4
${R2R3interfaceIP}              150.1.1.4
${R3R2interfaceIP}              150.1.1.3
${R3H2interfaceIP}              172.16.1.2
${user}                         vyatta
${pa}                           vyatta
#---------------END------------------------------------------

# DO NOT MODIFY BELOW THIS LINE
#R1
${R1tunnelinterfaceLocal}       ${R1R2interfaceIP}
${R1tunnelinterfaceRemote}      ${R3R2interfaceIP}
${R1protocolnwIP}               ${R1R2network}
${R1ipsecvpnpeerIP}             ${R3R2interfaceIP}
${R1ipsecvpnlocalIP}            ${R1R2interfaceIP}
${R1ipsecvpnPeerLocalPrefix}    ${R1H1network}
${R1ipsecvpnPeerRemotePrefix}   ${R3H2network}
${R1_e2e_pingcheck_ip}          ${R3H2interfaceIP}

#R2
${R2protocolnw1IP}              ${R1R2network}
${R2protocolnw2IP}              ${R2R3network}

#R3
${R3tunnelinterfaceLocal}       ${R3R2interfaceIP}
${R3tunnelinterfaceRemote}      ${R1R2interfaceIP}
${R3protocolnwIP}               ${R2R3network}
${R3ipsecvpnpeerIP}             ${R1R2interfaceIP}
${R3ipsecvpnlocalIP}            ${R3R2interfaceIP}
${R3ipsecvpnPeerLocalPrefix}    ${R3H2network}
${R3ipsecvpnPeerRemotePrefix}   ${R1H1network}
${R3_e2e_pingcheck_ip}          ${R1H1interfaceIP}

#--------------------------------------------
${validate_ospf_status}=          run show protocols ospf neighbor
${validate_vpn_tunnel_status}=    run show vpn ipsec sa
${validate_vpn_ipsec_status}=     run show vpn ipsec status
@{R1_pingcheck}=                  ${R2R1interfaceIP}    ${R2R3interfaceIP}    ${R3R2interfaceIP}
@{R2_pingcheck}=                  ${R1R2interfaceIP}    ${R3R2interfaceIP}
@{R3_pingcheck}=                  ${R2R3interfaceIP}    ${R1R2interfaceIP}    ${R2R1interfaceIP}

@{R1_interface_config}=
...    interfaces dataplane ${R1H1interface} address ${R1H1interfaceIP}/24
...    interfaces dataplane ${R1R2interface} address ${R1R2interfaceIP}/24

@{R1_interface_tunnel_config}=
...    interfaces tunnel tun0 local-ip ${R1tunnelinterfaceLocal}
...    interfaces tunnel tun0 remote-ip ${R1tunnelinterfaceRemote}
...    interfaces tunnel tun0 encapsulation gre

@{R1_protocol_config}=    protocols ospf area 0 network ${R1R2network}/24

@{R1_ipsec_vpn_config}=
...    security vpn ike make-before-break
...    security vpn ipsec esp-group vm1-esp proposal 1 encryption aes128gcm128
...    security vpn ipsec esp-group vm1-esp proposal 1 hash null
...    security vpn ipsec ike-group vm1-ike ike-version 2
...    security vpn ipsec ike-group vm1-ike proposal 1 dh-group 19
...    security vpn ipsec ike-group vm1-ike proposal 1 encryption aes128gcm128
...    security vpn ipsec ike-group vm1-ike proposal 1 hash sha2_512
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP}
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP} authenticat mode pre-shared-secret
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP} authenticat pre-shared-secret test123
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP} default-esp-group vm1-esp
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP} ike-group vm1-ike
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP} local-address ${R1ipsecvpnlocalIP}
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP} tunnel 0
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP} tunnel 0 local prefix ${R1ipsecvpnPeerLocalPrefix}/24
...    security vpn ipsec site-to-site peer ${R1ipsecvpnpeerIP} tunnel 0 remote prefix ${R1ipsecvpnPeerRemotePrefix}/24

@{R2_interface_config}=
...    interfaces dataplane ${R2R1interface} address ${R2R1interfaceIP}/24
...    interfaces dataplane ${R2R3interface} address ${R2R3interfaceIP}/24

@{R2_protocol_config}=
...    protocols ospf area 0 network ${R1R2network}/24
...    protocols ospf area 0 network ${R2R3network}/24

@{R3_interface_config}=
...    interfaces dataplane ${R3R2interface} address ${R3R2interfaceIP}/24
...    interfaces dataplane ${R3H2interface} address ${R3H2interfaceIP}/24

@{R3_interface_tunnel_config}=
...    interfaces tunnel tun0 local-ip ${R3tunnelinterfaceLocal}
...    interfaces tunnel tun0 remote-ip ${R3tunnelinterfaceRemote}
...    interfaces tunnel tun0 encapsulation gre

@{R3_protocol_config}=     protocols ospf area 0 network ${R2R3network}/24

@{R3_ipsec_vpn_config}=
...   security vpn ike make-before-break
...   security vpn ipsec esp-group vm3-esp proposal 1 encryption aes128gcm128
...   security vpn ipsec esp-group vm3-esp proposal 1 hash null
...   security vpn ipsec ike-group vm2-ike ike-version 2
...   security vpn ipsec ike-group vm2-ike proposal 1 dh-group 19
...   security vpn ipsec ike-group vm2-ike proposal 1 encryption aes128gcm128
...   security vpn ipsec ike-group vm2-ike proposal 1 hash sha2_512
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP}
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP} authenticat mode pre-shared-secret
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP} authenticat pre-shared-secret test123
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP} default-esp-group vm3-esp
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP} ike-group vm2-ike
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP} local-address ${R3ipsecvpnlocalIP}
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP} tunnel 0
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP} tunnel 0 remote prefix ${R3ipsecvpnPeerRemotePrefix}/24
...   security vpn ipsec site-to-site peer ${R3ipsecvpnpeerIP} tunnel 0 local prefix ${R3ipsecvpnPeerLocalPrefix}/24
