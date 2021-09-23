# * Copyright (c) 2021-2022, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Settings ***
Metadata        Version           1.0
...             Date              22-September-2021
...             Author            Dinesh Krishna Bhatta

Documentation   A test suite for DANOS REST API functionalities
...             Ref: https://danosproject.atlassian.net/wiki/spaces/DAN/pages/62816258/Representational+State+Transfer+REST
...    Topology:-
...           +-----------------+                  +----------+   LAN I/F
...           | REST API Client |------------------| DANOS R1 |-----------
...           +-----------------+                  +----------+
...
...               Testplan Goals:-
...               1. Check pre-requisites and clear previous configurations
...               2. Verify GET & PUT operations
...               3. Verify SET perations
...               4. Verify DELETE operations
...               5. Tear down setup

Library           SSHLibrary
Library           String
Library           Process
Library           OperatingSystem
Resource          ../keyword/danos_restapi_keywords.robot
Resource          ../testdata/danos_restapi_testdata.robot

*** Variables ***

*** Test Cases ***
Prerequisite checks
    Prerequisite checks

Show device version information (GET and PUT operations)
    Show Device Version

Show Interfaces (GET and PUT operations)
    Show Interfaces

Show Interface Counters (GET and PUT operations)
    Show Interface Counters

Set Interface IP (GET, PUT, SET operations)
    Set Interface IP
    Validate Presense of IP Configuration via CLI

Delete Interface IP (GET, PUT, DELETE operations)
    Delete Interface IP
    Validate Deletion of IP Configuration via CLI

Set BGP Protocol (GET, PUT, SET operations)
    Set BGP Protocol
    Validate Presense of BGP Configuration via CLI

Delete BGP Protocol (GET, PUT, DELETE operations)
    Delete BGP Protocol
    Validate Deletion of BGP Configuration via CLI

Set Security Firewall (GET, PUT, SET operations)
    Set Security Firewall
    Validate Presense of Security Firewall Configuration via CLI

Delete Security Firewall (GET, PUT, DELETE operations)
    Delete Security Firewall
    Validate Deletion of Security Firewall Configuration via CLI

Set DNS Configuration (GET, PUT, SET operations)
    Set DNS Configuration
    Validate Presense of DNS Configuration via CLI

Delete DNS Configuration (GET, PUT, DELETE operations)
    Delete DNS Configuration
    Validate Deletion of DNS Configuration via CLI

Set OSPF Protocol (GET, PUT, SET operations)
    Set OSPF Protocol
    Validate Presense of OSPF Configuration via CLI

Delete OSPF Protocol (GET, PUT, DELETE operations)
    Delete OSPF Protocol
    Validate Deletion of OSPF Configuration via CLI

Set NTP Configuration (GET, PUT, SET operations)
    Set NTP Configuration
    Validate Presense of NTP Configuration via CLI

Delete NTP Configuration (GET, PUT, DELETE operations)
    Delete NTP Configuration
    Validate Deletion of NTP Configuration via CLI

Set ISIS Protocol (GET, PUT, SET operations)
    Set ISIS Protocol
    Validate Presense of ISIS Configuration via CLI

Delete ISIS Protocol (GET, PUT, DELETE operations)
    Delete ISIS Protocol
    Validate Deletion of ISIS Configuration via CLI

Set NAT Configuration (GET, PUT, SET operations)
    Set NAT Configuration
    Validate Presense of NAT Configuration via CLI

Delete NAT Configuration (GET, PUT, DELETE operations)
    Delete NAT Configuration
    Validate Deletion of NAT Configuration via CLI

Logout
    Logout
