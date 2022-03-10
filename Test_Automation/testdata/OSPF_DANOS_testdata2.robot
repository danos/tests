# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
*** Settings ***

*** Variables ***
# Test data file for IBGP test scenarios
# Topology-3 Router:-
#                       lo:1.1.1.1            lo:2.2.2.2              lo:3.3.3.3
#                       dp0s11-.2         dp0s11-.3  dp0s10-.3    dp0s10-.4
#       dp0s10-31.1.1.2/24  +----+   41.1.1.0/24  +----+   51.1.1.0/24   +----+  dp0s11-61.1.1.4/24
#                           |R1  |----------------| R2 |-----------------| R3 |
#                           +----+                +----+                 +----+

# Note: Once the topology is created, update this test data file with the values for management IP addresses,
#       network IP address, interface names details, username / passwd of danos router under below section

#---------------START----------------------------------------
${R1}                             192.168.203.155
${R2}                             192.168.203.156
${R3}                             192.168.203.157
${R4}                             192.168.203.158
${user}                           vyatta
${pa}                             vyatta

#Topo-2
${R1_edge_interface}              dp0s10
${R1R2_interface}                 dp0s11
${R2R1_interface}                 dp0s11
${R2_edge_interface}              dp0s10

${R1_edge_iface_ip}               31.1.1.2
${R1R2_iface_ip}                  41.1.1.2
${R2R1_iface_ip}                  41.1.1.3
${R2_edge_iface_ip}               51.1.1.3
${R1_lb_ip}                       1.1.1.1
${R2_lb_ip}                       2.2.2.2

${R1_ed_nw}                       31.1.1.0
${R1R2_nw}                        41.1.1.0
${R2R1_nw}                        41.1.1.0
${R2_ed_nw}                       51.1.1.0

${ospf_area_b}                    0
${R1_router_id}                   1.1.1.1
${R2_router_id}                   2.2.2.2

${higher_routerid}                5.5.5.5

${ospf_area_wr}                   @123

#Topo-2 end

${reset_proto_ospf}               reset protocols ospf
${show_ospf_neighbor}             show protocols ospf neighbor
${show_ospf_database}             show protocols ospf database
${show_ospf_database_nw}          show protocols ospf database network
${show_ospf_database_as}          show protocols ospf database asbr-summary
${show_ospf_database_ex}          show protocols ospf database external
${show_ospf_database_so}          show protocols ospf database self-originate

@{set_intf_disable}=
...    interfaces dataplane ${R1R2_interface} disable

@{set_intf_enable}=
...    interfaces dataplane ${R1R2_interface} disable

@{set_ospf_priority_h_r1}=
...    interfaces dataplane ${R1R2_interface} ip ospf priority 7

@{set_ospf_priority_l_r1}=
...    interfaces dataplane ${R1R2_interface} ip ospf priority 1

@{set_ospf_priority_h_r2}=
...    interfaces dataplane ${R1R2_interface} ip ospf priority 7

@{set_ospf_priority_l_r2}=
...    interfaces dataplane ${R1R2_interface} ip ospf priority 1

@{set_routerid_higher}
...    protocols ospf parameters router-id ${higher_routerid}

@{set_routerid_sameas_R1}
...    protocols ospf parameters router-id ${R1_router_id}

@{access}=
...    touch .hushlogin
...    show version

@{delete_config}=
...    interfaces
...    protocols ospf

@{delete_protocol}=
...    protocols ospf

@{del}=
...    protocols static
...    protocols ospf

@{R1_interface_config}=
...    interfaces dataplane ${R1_edge_interface} address ${R1_edge_iface_ip}/24
...    interfaces dataplane ${R1R2_interface} address ${R1R2_iface_ip}/24
...    interfaces loopback lo address ${R1_lb_ip}/32

@{R1_protocol_config}=
...    protocols ospf parameters router-id ${R1_router_id}
...    protocols ospf area ${ospf_area_b} network ${R1_ed_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R1R2_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R1_lb_ip}/32

@{R2_interface_config}=
...    interfaces dataplane ${R2R1_interface} address ${R2R1_iface_ip}/24
...    interfaces dataplane ${R2_edge_interface} address ${R2_edge_iface_ip}/24
...    interfaces loopback lo address ${R2_lb_ip}/32

@{R2_protocol_config}=
...    protocols ospf parameters router-id ${R2_router_id}
...    protocols ospf area ${ospf_area_b} network ${R2R1_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R2_ed_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R2_lb_ip}/32

@{R1_protocol_config_wrong_area}=
...    protocols ospf area ${ospf_area_wr} network ${R1_ed_nw}/24

@{R2_protocol_config_r1_routerid}=
...    protocols ospf parameters router-id ${R1_router_id}
...    protocols ospf area ${ospf_area_b} network ${R2R1_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R2_ed_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R2_lb_ip}/32

@{R1_interface_config_diff_MTU}=
...    interfaces dataplane ${R1_edge_interface} address ${R1_edge_iface_ip}/24
...    interfaces dataplane ${R1R2_interface} address ${R1R2_iface_ip}/24
...    interfaces loopback lo address ${R1_lb_ip}/32
...    interfaces dataplane ${R1_edge_interface} mtu 1000
...    interfaces dataplane ${R1R2_interface} mtu 1000

@{R2_interface_config_diff_MTU}=
...    interfaces dataplane ${R2R1_interface} address ${R2R1_iface_ip}/24
...    interfaces dataplane ${R2_edge_interface} address ${R2_edge_iface_ip}/24
...    interfaces loopback lo address ${R2_lb_ip}/32
...    interfaces dataplane ${R2R1_interface} mtu 250
...    interfaces dataplane ${R2_edge_interface} mtu 250

@{modify_mtu_R1}=
...    interfaces dataplane ${R1_edge_interface} mtu 250
...    interfaces dataplane ${R1R2_interface} mtu 250

#Topo-3
${R1_edge_interface}              dp0s10
${R1R2_interface}                 dp0s11
${R2R1_interface}                 dp0s11
${R2R3_interface}                 dp0s10
${R3R2_interface}                 dp0s10
${R3_edge_interface}              dp0s11

${R1_edge_iface_ip}               31.1.1.2
${R1R2_iface_ip}                  41.1.1.2
${R2R1_iface_ip}                  41.1.1.3
${R2R3_iface_ip}                  51.1.1.3
${R3R2_iface_ip}                  51.1.1.4
${R3_edge_iface_ip}               61.1.1.4
${R1_lb_ip}                       1.1.1.1
${R2_lb_ip_1}                     2.2.2.2
${R2_lb_ip_2}                     3.3.3.3
${R3_lb_ip}                       4.4.4.4

${R1_ed_nw}                       31.1.1.0
${R1R2_nw}                        41.1.1.0
${R2R1_nw}                        41.1.1.0
${R2R3_nw}                        51.1.1.0
${R3R2_nw}                        51.1.1.0
${R3_ed_nw}                       61.1.1.0

${ospf_area_b}                    0
${ospf_area_1}                    1
${R1_router_id}                   1.1.1.1
${R2_router_id}                   2.2.2.2
${R3_router_id}                   3.3.3.3

@{R1_interface_config_3}=
...    interfaces dataplane ${R1_edge_interface} address ${R1_edge_iface_ip}/24
...    interfaces dataplane ${R1R2_interface} address ${R1R2_iface_ip}/24
...    interfaces loopback lo address ${R1_lb_ip}/32

@{R1_protocol_config_3}=
...    protocols ospf parameters router-id ${R1_router_id}
...    protocols ospf area ${ospf_area_b} network ${R1_ed_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R1R2_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R1_lb_ip}/32

@{R1_protocol_config_3_wo_router-id}=
...    protocols ospf area ${ospf_area_b} network ${R1_ed_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R1R2_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R1_lb_ip}/32

@{R2_interface_config_3}=
...    interfaces dataplane ${R2R1_interface} address ${R2R1_iface_ip}/24
...    interfaces dataplane ${R2R3_interface} address ${R2R3_iface_ip}/24
...    interfaces loopback lo address ${R2_lb_ip_1}/32
...    interfaces loopback lo address ${R2_lb_ip_2}/32

@{R2_protocol_config_3}=
...    protocols ospf parameters router-id ${R2_router_id}
...    protocols ospf area ${ospf_area_b} network ${R2R1_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R2_lb_ip_1}/32
...    protocols ospf area ${ospf_area_1} network ${R2R3_nw}/24
...    protocols ospf area ${ospf_area_1} network ${R2_lb_ip_2}/32

@{R2_protocol_config_3_wo_router-id}=
...    protocols ospf area ${ospf_area_b} network ${R2R1_nw}/24
...    protocols ospf area ${ospf_area_b} network ${R2_lb_ip_1}/32
...    protocols ospf area ${ospf_area_1} network ${R2R3_nw}/24
...    protocols ospf area ${ospf_area_1} network ${R2_lb_ip_2}/32

@{R3_interface_config_3}=
...    interfaces dataplane ${R3R2_interface} address ${R3R2_iface_ip}/24
...    interfaces dataplane ${R3_edge_interface} address ${R3_edge_iface_ip}/24
...    interfaces loopback lo address ${R3_lb_ip}/32

@{R3_protocol_config_3}=
...    protocols ospf parameters router-id ${R3_router_id}
...    protocols ospf area ${ospf_area_1} network ${R3R2_nw}/24
...    protocols ospf area ${ospf_area_1} network ${R3_ed_nw}/24
...    protocols ospf area ${ospf_area_1} network ${R3_lb_ip}/32

@{R3_protocol_config_3_wo_router-id}=
...    protocols ospf area ${ospf_area_1} network ${R3R2_nw}/24
...    protocols ospf area ${ospf_area_1} network ${R3_ed_nw}/24
...    protocols ospf area ${ospf_area_1} network ${R3_lb_ip}/32

@{R3_protocol_config_3_wo_lb}=
...    protocols ospf parameters router-id ${R3_router_id}
...    protocols ospf area ${ospf_area_1} network ${R3R2_nw}/24
...    protocols ospf area ${ospf_area_1} network ${R3_ed_nw}/24
...    set protocols ospf redistribute connected


#Topo-3 end
