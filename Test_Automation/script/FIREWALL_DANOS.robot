# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

*** Settings ***
Metadata        Version           1.0
...             Author            Dinesh Krishna Bhatta
...             Date              22-May-2020
...             Modified          24-Sep-2021 (Anson): Support for DANOS2105

Documentation   A test suite for Firewall functionalities testing using DANOS vRouter
...             HowToExecute:  python3 -m robot.run FIREWALL_DANOS.robot
...
...             Topology:-
...                         lo:1.1.1.1                   lo:2.2.2.2                      lo:3.3.3.3
...                           +----+           dp0s9    +-----------+            dp0s10   +----+
...                           |    |        65.1.1.3/24 |  DANOS    |         66.1.1.3/24 |    |
...              =============+ R1 +====================+ Firewall  +=====================+ R3 +=============
...               10.1.1.2/24 |    | 65.1.1.2/24        |    R2     | 66.1.1.2/24         |    | 172.16.1.2/24
...                  dp0s3    +----+   dp0s9            +-----------+   dp0s10            +----+    dp0s3
...
...               Testplan Goals:-
...               1. Check pre-requisites: Check ssh access to devices, enable cli mgmt
...               2. Clear configurations
...               3. Configure interfaces
...               4. Configure OSPF protocol
...               6. Validate OSPF protocol status and check topology connectivity
...               7. Verify End-to-End reachability
...               8. Test ICMP block / allow functionality
...               9. Test SSH block / allow functionality
...              10. Test ICMP block from a specific source IP
...              11. Test TELNET block / allow functionality
...              12. Teardown topology

Library           SSHLibrary
Library           String
Library           Collections
Resource           ../keyword/FIREWALL_DANOS_keywords.robot

*** Variables ***
${R1}      192.168.203.155
${R2}      192.168.203.156
${R3}      192.168.203.157

*** Test Cases ***
Perform prerequisites: Access, clean setup
    Access check and enable vymgmt support
    Clear configurations on the topology

Configure interfaces on all devices of topology
    Configure R1 interfaces
    Configure R2 interfaces
    Configure R3 interfaces

Configure OSPF protocol on R1, R2 and R3
    Configure routing protocol on R1
    Configure routing protocol on R2
    Configure routing protocol on R3
    Log    Waiting for few seconds to converge
    Sleep    40s

Validate OSPF protocol status and check topology connectivity
    Validate OSPF status on R1
    Validate OSPF status on R3
    Verify connectivity from R1
    Verify connectivity from R2
    Verify connectivity from R3
    Verify E2E reachability from R1
    Verify E2E reachability from R3

Test ICMP block functionality
    Create Firewall rule for blocking ICMP
    Apply blocking ICMP Firewall rule on the incoming interface
    Verify ping test and validate it is failing
    Remove blk-icmp firewall rule on the interface

Test ICMP allow functionality
    Create Firewall rule to Allow ICMP
    Apply Allow ICMP Firewall rule on the incoming interface
    Verify ping test and validate it is Passed
    Remove allow-icmp firewall rule on the interface

Test SSH block functionality
    Create Firewall rule for blocking SSH
    Apply blocking SSH Firewall rule on the incoming interface
    Verify SSH test and validate it is failing
    Remove blk-ssh firewall rule on the interface

Test SSH allow functionality
    Create Firewall rule for allowing SSH
    Apply allowing SSH Firewall rule on the incoming interface
    Verify SSH test and validate it is pass
    Remove allow-ssh firewall rule on the interface

Test ICMP blocking from a specific IP 
    Create Firewall rule to block ICMP from a specific source IP
    Apply blocking ICMP Firewall rule on the outgoing interface
    Verify ping test from the source device whose IP is used in the above firewall rule and test should fail
    Verify ping test from other device and test should pass
    Remove blk-icmp-from-ip firewall rule on the interface

Test SMTP block functionality
    Create Firewall rule for blocking SMTP
    Apply blocking SMTP Firewall rule on the incoming interface
    Verify SMTP is blocked
    Remove blk-smtp firewall rule on the interface

Test DNS block functionality
    Create Firewall rule for blocking DNS
    Apply blocking DNS Firewall rule on the incoming interface
    Verify DNS is blocked
    Remove blk-dns firewall rule on the interface

Test HTTPS block functionality
    Create Firewall rule for blocking HTTPS
    Apply blocking HTTPS Firewall rule on the incoming interface
    Verify HTTPS is blocked
    Remove blk-https firewall rule on the interface

Test HTTP block functionality
    Create Firewall rule for blocking HTTP
    Apply blocking HTTP Firewall rule on the incoming interface
    Verify HTTP is blocked
    Remove blk-http firewall rule on the interface

Test TELNET block functionality
    Create Firewall rule for blocking TELNET
    Apply blocking TELNET Firewall rule on the incoming interface
    Verify TELNET test and validate it is failing
    Remove blk-telnet firewall rule on the interface

Test TELNET allow functionality
   Create Firewall rule for allowing TELNET
   Apply allowing TELNET Firewall rule on the incoming interface
   Verify TELNET test and validate it is pass
   Remove allow-telnet firewall rule on the interface

Teardown topology
    Clear configurations on the topology
