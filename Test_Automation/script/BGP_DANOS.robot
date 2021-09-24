# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Settings ***
Metadata        Version           1.0
...             Date              20-August-2020
...             Author            Dinesh Krishna Bhatta
...             Modified          24-Sep-2021 (Dinesh) - support for DANOS2105

Documentation   A test suite for BGP test scenarios with DANOS vRouter
...    Topology:-
...                             dp0s9  +-----+ dp0s3
...                       +------------+  R4 +-------------+
...                      /             +--+--+              \
...        205.1.1.0/24 /                 | dp0s10           \
...                    /                  |                   \ 204.1.1.0/24
...                   /       203.1.1.0/24|                    \
...                  /                    |                     \
...           dp0s9 /                     |  dp0s10              \ dp0s3
...             +--+--+  201.1.1.0/24  +--+--+  202.1.1.0/24   +--+--+
...             |  R1 +----------------+  R2 +-----------------+  R3 |
...             +--+--+ dp0s3    dp0s3 +-----+ dp0s9     dp0s9 +--+--+
...         dp0sX /   <======EBGP======>     <=======IBGP======>   \ dp0sX
...              /                                                  \
...             / 10.1.1.0/24                            13.1.1.0/24 \
...            /                                                      \
...        +--+---+                                                +---+--+
...        | LAN1 |                                                | LAN2 |
...        +------+                                                +------+
...
...               Testplan Goals:-
...               1. Check pre-requisites: Check ssh access to devices, enable cli mgmt
...               2. Clear configurations
...               3. Configure interfaces
...               4. Configure BGP protocol
...               5. Test Route Reflector with all 3 rules
...               6. Validate Next-hop attribute
...               7. Verify EBGP on directly connected neighbors
...               8. Verify EBGP Neighbor with Multihop option
...               9. Verify iBGP on directly connected neighbors
...              10. Verify iBGP Neighbor with Multihop option
...              11. Validate BGP route selection between iBGP v/s eBGP
...              12. Verify local preference
...              13. Validate BGP confederation
...              14. Verify Route Flaping/dampening Feature
...              15. Clear configurations

Library           SSHLibrary
Library           String
Library           Collections
Resource           ../keyword/BGP_DANOS_keywords.robot
Resource           ../testdata/BGP_DANOS_testdata.robot

*** Variables ***


*** Test Cases ***
Access devices
    Access devices
    Access check and enable vymgmt support
    Clear configurations on the topology
    Show Interfaces

Configure interfaces on the devices
    Configure interfaces
    Show Interfaces

Route Reflector Rule-1 Configuration and verification
    Route Reflector Rule-1 Configuration and verification

Validate Next-hop attribute
    Validate Next-hop attribute

Route Reflector Rule-2 Configuration and verification
    Route Reflector Rule-2 Configuration and verification

Route Reflector Rule-3 Configuration and verification
    Route Reflector Rule-3 Configuration and verification

Verify EBGP on directly connected neighbors
    Verify EBGP on directly connected neighbors

Verify EBGP Neighbor with Multihop option
    Verify EBGP Neighbor with Multihop option

Verify iBGP on directly connected neighbors
    Verify iBGP on directly connected neighbors

Verify iBGP Neighbor with Multihop option
    Verify iBGP Neighbor with Multihop option

Validate BGP route selection between iBGP v/s eBGP
    Clear configurations on the topology
    Validate BGP route selection between iBGP v/s eBGP

Verify local preference
    Verify local preference

Validate BGP confederation
    Clear configurations on the topology
    Validate BGP confederation

Verify Route Flaping/dampening Feature
    Verify Route Flaping/dampening Feature

Teardown setup
    Clear configurations on the topology

Logout
    Logout
