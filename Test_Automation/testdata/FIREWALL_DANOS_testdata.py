#!/usr/bin/python3
# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only


validate_ospf_neighbor_status = 'run show protocols ospf neighbor'
validate_ospf_database_status = 'run show protocols ospf database'
validate_ospf_interface_status = 'run show protocols ospf interface dp0s3'
validate_ospf_route_status = 'run show protocols ospf route'
validate_ospf_status = 'run show protocols ospf neighbor'
R1_pingcheck = ['65.1.1.3', '66.1.1.2', '66.1.1.3']
R2_pingcheck = ['65.1.1.2', '66.1.1.3']
R3_pingcheck = ['66.1.1.2', '65.1.1.3', '65.1.1.2']
R1_e2e_pingcheck_ip = '172.16.1.2'
R3_e2e_pingcheck_ip = '10.1.1.2'

R1_interface_config = [
'interfaces loopback lo address 1.1.1.1/32',
'interfaces dataplane dp0s9 address 65.1.1.2/24',
'interfaces dataplane dp0s8 address 10.1.1.2/24',
]

R1_ospf_protocol_config = [
'protocols ospf area 0 network 1.1.1.1/32',
'protocols ospf area 0 network 65.1.1.0/24',
'protocols ospf area 0 network 10.1.1.0/24',
]

R2_interface_config = [
'interfaces loopback lo address 2.2.2.2/32',
'interfaces dataplane dp0s9 address 65.1.1.3/24',
'interfaces dataplane dp0s10 address 66.1.1.2/24',
]

R2_ospf_protocol_config = [
'protocols ospf area 0 network 2.2.2.2/32',
'protocols ospf area 0 network 65.1.1.0/24',
'protocols ospf area 0 network 66.1.1.0/24',
]

R3_interface_config = [
'interfaces loopback lo address 3.3.3.3/32',
'interfaces dataplane dp0s10 address 66.1.1.3/24',
'interfaces dataplane dp0s9 address 172.16.1.2/24',
]

R3_ospf_protocol_config = [
'protocols ospf area 0 network 3.3.3.3/32',
'protocols ospf area 0 network 66.1.1.0/24',
'protocols ospf area 0 network 172.16.1.0/24',
]

blk_icmp = [
'security firewall name blk-icmp rule 15 action drop',
'security firewall name blk-icmp rule 15 protocol icmp',
]

allow_icmp = [
'security firewall name allow-icmp rule 16 action accept',
'security firewall name allow-icmp rule 16 protocol icmp',
]

blk_telnet = [
'security firewall name blk-telnet rule 17 action drop',
'security firewall name blk-telnet rule 17 protocol tcp',
'security firewall name blk-telnet rule 17 destination port 23',
]

allow_telnet = [
'security firewall name allow-telnet rule 18 action accept',
'security firewall name allow-telnet rule 18 protocol tcp',
'security firewall name allow-telnet rule 18 destination port 23',
]

blk_ssh = [
'security firewall name blk-ssh rule 19 action drop',
'security firewall name blk-ssh rule 19 protocol tcp',
'security firewall name blk-ssh rule 19 destination port 22',
]

allow_ssh = [
'security firewall name allow-ssh rule 20 action accept',
'security firewall name allow-ssh rule 20 protocol tcp',
'security firewall name allow-ssh rule 20 destination port 22',
]

blk_tftp = [
'security firewall name blk-tftp rule 21 action drop',
'security firewall name blk-tftp rule 21 protocol udp',
'security firewall name blk-tftp rule 21 destination port 69',
]

allow_tftp = [
'security firewall name allow-tftp rule 22 action accept',
'security firewall name allow-tftp rule 22 protocol udp',
'security firewall name allow-tftp rule 22 destination port 69',
]

blk_icmp_from_ip = [
'security firewall name blk-icmp-from-ip rule 23 action drop',
'security firewall name blk-icmp-from-ip rule 23 protocol icmp',
'security firewall name blk-icmp-from-ip rule 23 source address 65.1.1.2',
]

APPLY_RULE_CMD = 'interfaces dataplane INTERFACE firewall in RULE'
APPLY_RULE_CMD_OUT = 'interfaces dataplane INTERFACE firewall out RULE'

blk_smtp = [
'security firewall name blk-smtp rule 25 action drop',
'security firewall name blk-smtp rule 25 protocol tcp',
'security firewall name blk-smtp rule 25 destination port 25',
]

blk_dns = [
'security firewall name blk-dns rule 26 action drop',
'security firewall name blk-dns rule 26 protocol tcp',
'security firewall name blk-dns rule 26 destination port 53',
]

blk_https = [
'security firewall name blk-https rule 27 action drop',
'security firewall name blk-https rule 27 protocol tcp',
'security firewall name blk-https rule 27 destination port 443',
]

blk_http = [
'security firewall name blk-http rule 28 action drop',
'security firewall name blk-http rule 28 protocol tcp',
'security firewall name blk-http rule 28 destination port 80',
]
