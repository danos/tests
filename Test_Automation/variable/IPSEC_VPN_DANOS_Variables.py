#!/usr/bin/python3
# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

validate_ospf_status = 'run show protocols ospf neighbor'
validate_vpn_tunnel_status = 'run show vpn ipsec sa'
validate_vpn_ipsec_status = 'run show vpn ipsec status'
R1_pingcheck = ['R2R1interfaceIP', 'R2R3interfaceIP', 'R3R2interfaceIP']
R2_pingcheck = ['R1R2interfaceIP', 'R3R2interfaceIP']
R3_pingcheck = ['R2R3interfaceIP', 'R1R2interfaceIP', 'R2R1interfaceIP']

R1_interface_config = [
'interfaces dataplane R1H1interface address INTERFACE1IP/24',
'interfaces dataplane R1R2interface address INTERFACE2IP/24',
]

R1_interface_tunnel_config = [
'interfaces tunnel tun0 local-ip R1tunnelinterfaceLocal',
'interfaces tunnel tun0 remote-ip R1tunnelinterfaceRemote',
'interfaces tunnel tun0 encapsulation gre',
]

R1_protocol_config = ['protocols ospf area 0 network NW/24',]

R1_ipsec_vpn_config = [
'security vpn ike make-before-break',
'security vpn ipsec esp-group vm1-esp proposal 1 encryption aes128gcm128',
'security vpn ipsec esp-group vm1-esp proposal 1 hash null',
'security vpn ipsec ike-group vm1-ike ike-version 2',
'security vpn ipsec ike-group vm1-ike proposal 1 dh-group 19',
'security vpn ipsec ike-group vm1-ike proposal 1 encryption aes128gcm128',
'security vpn ipsec ike-group vm1-ike proposal 1 hash sha2_512',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP authenticat mode pre-shared-secret',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP authenticat pre-shared-secret test123',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP default-esp-group vm1-esp',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP ike-group vm1-ike ',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP local-address R1ipsecvpnlocalIP',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP tunnel 0',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP tunnel 0 local prefix R1ipsecvpnPeerLocalPrefix/24',
'security vpn ipsec site-to-site peer R1ipsecvpnpeerIP tunnel 0 remote prefix R1ipsecvpnPeerRemotePrefix/24',
]

R2_interface_config = [
'interfaces dataplane R2R1interface address INTERFACE1IP/24',
'interfaces dataplane R2R3interface address INTERFACE2IP/24',
]

R2_protocol_config = [
'protocols ospf area 0 network NW/24',
'protocols ospf area 0 network NW/24',
]

R3_interface_config = [
'interfaces dataplane R3R2interface address INTERFACE1IP/24',
'interfaces dataplane R3H2interface address INTERFACE2IP/24',
]

R3_interface_tunnel_config = [
'interfaces tunnel tun0 local-ip R3tunnelinterfaceLocal',
'interfaces tunnel tun0 remote-ip R3tunnelinterfaceRemote',
'interfaces tunnel tun0 encapsulation gre',
]

R3_protocol_config = ['protocols ospf area 0 network NW/24',]

R3_ipsec_vpn_config = [
'security vpn ike make-before-break',
'security vpn ipsec esp-group vm3-esp proposal 1 encryption aes128gcm128',
'security vpn ipsec esp-group vm3-esp proposal 1 hash null',
'security vpn ipsec ike-group vm2-ike ike-version 2',
'security vpn ipsec ike-group vm2-ike proposal 1 dh-group 19',
'security vpn ipsec ike-group vm2-ike proposal 1 encryption aes128gcm128',
'security vpn ipsec ike-group vm2-ike proposal 1 hash sha2_512',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP authenticat mode pre-shared-secret',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP authenticat pre-shared-secret test123',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP default-esp-group vm3-esp',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP ike-group vm2-ike ',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP local-address R3ipsecvpnlocalIP',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP tunnel 0',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP tunnel 0 remote prefix R3ipsecvpnPeerRemotePrefix/24',
'security vpn ipsec site-to-site peer R3ipsecvpnpeerIP tunnel 0 local prefix R3ipsecvpnPeerLocalPrefix/24',
]
