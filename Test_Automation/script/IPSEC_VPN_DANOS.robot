# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Settings ***
Metadata        Version           1.0
...             Date              07-July-2020

Documentation   A test suite for site-to-site VPN using IPsec with DANOS vRouter
...
...             Topology:-
...                           +----+  140.1.1.0/24  +----+  150.1.1.0/24   +----+
...               Head Office | R1 |----------------| R2 |-----------------| R3 | Branch Office
...                           +----+                +----+                 +----+
...                             /    <=========== IPSEC Tunnel ==========>    \
...                            /                                               \
...                           / 10.1.1.0/24                                     \  172.16.1.0/24
...                          /                                                   \
...                       +------+                                              +------+
...                       | LAN1 |                                              | LAN2 |
...                       +------+                                              +------+
...
...               Testplan Goals:-
...               1. Check pre-requisites: Check ssh access to devices, enable cli mgmt
...               2. Clear configurations
...               3. Configure interfaces
...               4. Configure OSPF protocol
...               5. Configure interface tunnel
...               6. Configure IPSEC VPN
...               7. Verify topology connectivity on the configured interface IPs from each device
...               8. Validate OSPF protocol status
...               9. Validate interface tunnel status
...              10. Validate IPSEC VPN status
...              11. Verify End-to-End reachability
...              12. Validate IPSec tunnel is able to encrypt/decrypt the packets

Library           SSHLibrary
Library           String
Library           Collections
Resource           ../keyword/IPSEC_VPN_DANOS_keywords.robot
Resource           ../testdata/IPSEC_VPN_DANOS_testdata.robot

*** Variables ***

*** Test Cases ***
Perform prerequisite checks(Access, Enable cli management & Clear config)
    Access check and enable vymgmt support
    Clear configurations on the topology

Configure interfaces on all devices of topology
    Configure R1 interfaces
    Configure R2 interfaces
    Configure R3 interfaces

Configure OSPF protocol on routers R1, R2 and R3
    Configure routing protocol on R1
    Configure routing protocol on R2
    Configure routing protocol on R3
    Log    Waiting for few seconds to converge
    Sleep    30s

Configure IPSEC VPN between Head-Office and Branch-Office
    Configure R1 interface tunnel
    Configure R3 interface tunnel
    Configure R1 IPSEC VPN
    Configure R3 IPSEC VPN
    Log    Waiting for few seconds to converge
    Sleep    10s

Validate OSPF protocol status and check topology connectivity
    Validate OSPF status on R1
    Validate OSPF status on R3
    Verify connectivity from R1
    Verify connectivity from R2
    Verify connectivity from R3

Validate IPSEC VPN configuration status
    Validate VPN tunnel status on R1
    Validate VPN tunnel status on R3
    Validate VPN IPSEC status on R1
    Validate VPN IPSEC status on R3

Verify E2E reachability between Head-Office and Branch-Office
    Verify E2E reachability from R1
    Verify E2E reachability from R3

Send traffic and validate it is received at destination
    Send traffic and validate it is received

Validate VPN traffic encrypted in the network
    Validate VPN traffic is encrypted in the network

Teardown topology
    Clear configurations on the topology
