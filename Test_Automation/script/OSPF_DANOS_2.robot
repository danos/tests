# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
*** Settings ***
Metadata        Version           1.0
...             More Info         For more information about Robot Framework see http://robotframework.org
...             Author            Rupam Mallick
...             Date              28-Aug-2020
...             Executed At
...             Test Framework    Robot Framework Python

Documentation   A test suite for OSPF test scenario with DANOS vRouter
...
...             Topology-3 Router:-
...                       lo:1.1.1.1            lo:2.2.2.2              lo:3.3.3.3
...                       dp0s11-.2         dp0s11-.3  dp0s10-.3    dp0s10-.4
...       dp0s10-31.1.1.2/24  +----+   41.1.1.0/24  +----+   51.1.1.0/24   +----+  dp0s11-61.1.1.4/24
...                           |R1  |----------------| R2 |-----------------| R3 |
...                           +----+                +----+                 +----+
...                           Area0             Area0    Area1              Area1
...
...               Testplan Goals:-
...               1. Check pre-requisites: Check ssh access to devices, enable cli mgmt
...               2. Clear configurations
...               3. Configure interfaces
...               4. Configure OSPF protocol
...               6. Validate OSPF protocol status and check topology connectivity
...               7. Reset OSPF protocol on both devices and Validate Status 
...               8. Validate OSPF protocol DR/Backup election accordingly highest Router-id
...               9. Validate OSPF protocol DR/Backup election accordingly highest Priority
...              10. Validate OSPF protocol DR/Backup election accordingly highest Active Interface ip
...              11. Validate OSPF protocol DR/Backup election accordingly highest Priority on Active Interface ip
...              12. Validate OSPF Database status Network LSA on Routers
...              13. Validate OSPF Database status in Multi-area
...              14. Verify Error message incase of Wrong Area-id configuration
...              15. Teardown topology

Library           SSHLibrary
Library           String
Library           Collections
Resource          ../keyword/OSPF_DANOS_keywords2.robot

*** Variables ***

*** Test Cases ***
Access 2 devices
    Access 2 devices
    Access check and enable vymgmt support in 2 devices
    Clear configurations on the topology in 2 devices
    Show Interfaces in 2 devices

Configure interfaces on the 2 devices
    Configure interfaces in 2 devices
    Show Interfaces in 2 devices

Configure OSPF protocol on 2 devices and Validate All Status in R1
    Configure routing protocol in 2 devices
    Validate OSPF neighbor status Init on R1
    Validate OSPF neighbor status 2-Way on R1
    Validate OSPF neighbor status ExStart on R1
    Validate OSPF neighbor status Full on R1

Reset OSPF protocol on both devices and Validate 2-Way and Full Status in R2
    Reset OSPF protocol on R1
    Reset OSPF protocol on R2
    Validate OSPF neighbor status 2-Way on R2
    Validate OSPF neighbor status Full on R2

Validate OSPF protocol DR/Backup election accordingly highest Router-id
    Validate OSPF neighbor election - DR on R1
    Validate OSPF neighbor election - Backup on R2

Validate OSPF protocol DR/Backup election accordingly highest Priority
    Modify OSPF High Priority on R1
    Reset OSPF protocol on R1
    Reset OSPF protocol on R2
    Validate OSPF neighbor election DR on R2
    Validate OSPF neighbor election Backup on R1
    Modify OSPF High Priority on R2
    Reset OSPF protocol on R1
    Reset OSPF protocol on R2
    Validate OSPF neighbor election DR on R1
    Validate OSPF neighbor election Backup on R2

Access 3 devices
    Access 3 devices
    Access check and enable vymgmt support in 3 devices
    Clear configurations on the topology in 3 devices
    Show Interfaces in 3 devices

Configure interfaces on the 3 devices
    Configure interfaces in 3 devices
    Show Interfaces in 3 devices

Validate OSPF protocol DR/Backup election accordingly highest Active Interface ip among 3 Routers
    Configure routing protocol without Router-id in 3 devices
    Validate OSPF neighbor election DR on R1
    Validate OSPF neighbor election DR on R2
    Validate OSPF neighbor election Backup on R2
    Validate OSPF neighbor election Backup on R3

Validate OSPF protocol DR/Backup election accordingly highest Priority on Active Interface ip among 3 Routers
    Modify OSPF High Priority on R1
    Reset OSPF protocol on R1
    Reset OSPF protocol on R2
    Reset OSPF protocol on R3
    Validate OSPF neighbor election DR on R2 with highest priority
    Clear configurations on the topology in 3 devices

Configure interfaces and routing protocol on the 3 devices
    Clear configurations on the topology in 3 devices
    Configure interfaces in 3 devices
    Show Interfaces in 3 devices
    Configure routing protocol in 3 devices

Validate OSPF Database status Network LSA on R1, R2, R3
    Validate OSPF Database status Network LSA on Router-1
    Validate OSPF Database status Network LSA on Router-2
    Validate OSPF Database status Network LSA on Router-3

Validate OSPF Database status in Multi-area
    Validate OSPF Database status on R1 in Multi-area
    Validate OSPF Database status on R2 in Multi-area
    Validate OSPF Database status on R3 in Multi-area
    Clear configurations on the topology in 3 devices

Verify Error message incase of Wrong Area-id configuration
    Configure interfaces in 2 devices
    Configure routing protocol with wrong area and Validate the error in R1
    Clear configurations on the topology in 2 devices

Teardown topology
    Clear configurations on the topology in 2 devices
    Clear configurations on the topology in 3 devices
