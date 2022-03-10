# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Settings ***
Metadata        Version           1.0
...             Author            Velmurugan M
...             How To Execute:   python3 -m robot.run MPLS_LDP_DANOS_netconf.robot
...             Date              30-June-2020
...             Date              03-Dec-2021 - Added support for DANOS2105 image (Vidyashree)

Documentation   A Netconf test suite for MPLS LDP test scenario with DANOS vRouter. Complete configuration and validation
...             is done using netconf rpc requests.
...
...             Topology:-
...                       lo:1.1.1.1            lo:2.2.2.2              lo:3.3.3.3
...                           +----+   20.1.1.0/24  +----+   30.1.1.0/24   +----+
...                           |PE1 |----------------| P1 |-----------------| PE2|
...                           +----+                +----+                 +----+
...                             /                                             \
...                            /                                               \
...                           /                                                 \
...                          /                                                   \
...                        +----+                                              +----+
...                        | H1 |                                              | H2 |
...                        +----+                                              +----+
...                      10.1.1.0/24                                         172.16.1.0/24
...
...               Testplan Goals:-
...               1. Check pre-requisites: Access to the devices and enable netconf
...               2. Clear configurations
...               3. Configure interfaces
...               4. Configure OSPF protocol
...               5. Configure MPLS LDP
...               6. Validate OSPF protocol status and check topology connectivity
...               7. Validate MPLS-LDP Neighbor status
...               8. Validate MPLS-LDP IPv4 interface status
...               9. Validate MPLS-LDP IPv4 discovery status
...              10. Validate MPLS-LDP IPv4 binding status
...              11. Verify End-to-End reachability
...              12. Teardown topology

Library           SSHLibrary
Library           String
Library           Collections
Resource           ../keyword/MPLS_LDP_DANOS_netconf_keywords.robot

*** Test Cases ***
Perform prerequisites: Access, clean setup
   Clear netconf configurations
   Clear configurations on the topology
   
Configure interfaces on all devices of topology
    Configure PE1 interfaces
    Configure P1 interfaces
    Configure PE2 interfaces

Configure OSPF protocol on PE1, P1 and PE2
    Configure routing protocol on PE1
    Configure routing protocol on P1
    Configure routing protocol on PE2
    Log    Waiting for few seconds to converge
    Sleep    40s

Configure MPLS LDP netconf
    Configure MPLS LDP on PE1
    Configure MPLS LDP on P1
    Configure MPLS LDP on PE2

Validate OSPF protocol status and check topology connectivity
    Validate OSPF status on PE1
    Validate OSPF status on PE2
    Verify connectivity from PE1
    Verify connectivity from P1
    Verify connectivity from PE2

Validate MPLS-LDP Neighbor status
    Validate MPLS-LDP Neighbor status

Validate MPLS-LDP IPv4 interface status
    Validate MPLS-LDP IPv4 interface status

Validate MPLS-LDP IPv4 discovery status
    Validate MPLS-LDP IPv4 discovery status on PE1
    Validate MPLS-LDP IPv4 discovery status on P1
    Validate MPLS-LDP IPv4 discovery status on PE2

Validate MPLS-LDP IPv4 binding status
    Validate MPLS-LDP IPv4 binding status on PE1
    Validate MPLS-LDP IPv4 binding status on P1
    Validate MPLS-LDP IPv4 binding status on PE2

Verify E2E reachability
    Verify E2E reachability from PE1
    Verify E2E reachability from PE2

Teardown topology netconf
    Clear configurations on the topology
    Clear netconf configurations
