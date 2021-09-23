# * Copyright (c) 2021-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
*** Settings ***

*** Variables ***
# Test data file for REST API tests
#Topology:-
#             +-----------------+                  +----------+   LAN I/F
#             | REST API Client |------------------| DANOS R1 |-----------
#             +-----------------+                  +----------+
#
# Note: Once the topology is created, update this test data file with the values for management IP addresses,
#       network IP address, interface names details, username / passwd of danos router under below section

#---------------START----------------------------------------
${RESTClient}                     192.168.203.6
${u}                              test
${p}                              test123
${HOST1}                          192.168.203.231
${user}                           vyatta
${pa}                             vyatta
${dest}                           192.168.203.4
${R1LAN1_interface}               dp0s9
${R1LAN1_iface_ip}                11.22.33.44

#---------------END------------------------------------------
${show_iface}                     show interfaces
${show_bgp}                       show configuration | grep "bgp 22"
${show_ospf}                      show configuration | grep "ospf"
${show_isis}                      show configuration | grep "isis testing"
${show_firewall}                  show configuration | grep "fwtest"
${show_dns}                       show configuration | grep "dns"
${show_ntp}                       show configuration | grep "ntp"
${show_nat}                       show configuration | grep "nat"
${show_version}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/op/show/version
${get_version_str}=    Location:\\s+rest\/op\/(.*)\\n
${show_interfaces}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/op/show/interfaces
${show_interface_counters}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/op/show/interface/counters

${set_interface_ip_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${set_interface_ip_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/set/interfaces/dataplane/${R1LAN1_interface}/address/${R1LAN1_iface_ip}%2F24
${set_interface_ip_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${del_interface_ip_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${del_interface_ip_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/delete/interfaces/dataplane/${R1LAN1_interface}/address/${R1LAN1_iface_ip}%2F24
${del_interface_ip_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${set_bgp_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${set_bgp_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/set/protocols/bgp/22
${set_bgp_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${del_bgp_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${del_bgp_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/delete/protocols/bgp
${del_bgp_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${set_ospf_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${set_ospf_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/set/protocols/ospf/area/33
${set_ospf_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${del_ospf_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${del_ospf_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/delete/protocols/ospf
${del_ospf_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${set_isis_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${set_isis_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/set/protocols/isis/testing
${set_isis_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${del_isis_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${del_isis_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/delete/protocols/isis
${del_isis_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${set_firewall_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${set_firewall_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/set/security/firewall/name/fwtest
${set_firewall_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${del_firewall_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${del_firewall_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/delete/security/firewall
${del_firewall_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${set_dns_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${set_dns_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/set/service/dns
${set_dns_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${del_dns_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${del_dns_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/delete/service/dns
${del_dns_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${set_ntp_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${set_ntp_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/set/system/ntp
${set_ntp_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${del_ntp_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${del_ntp_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/delete/system/ntp
${del_ntp_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${set_nat_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${set_nat_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/set/service/nat
${set_nat_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${del_nat_post}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf
${del_nat_put}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X PUT https://${HOST1}/rest/conf/CONFID/delete/service/nat
${del_nat_commit}=     curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X POST https://${HOST1}/rest/conf/CONFID/commit

${delete_op_id}=    curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X DELETE https://${HOST1}/rest/op/
${delete_conf_id}=    curl -k -s -i -u ${user}:${pa} -H \"content-length:0\" -H \"Accept: application/json\" -X DELETE https://${HOST1}/rest/conf/
