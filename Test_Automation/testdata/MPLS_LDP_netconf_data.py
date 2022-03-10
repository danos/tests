#!/usr/bin/python3
# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
hosts = ['192.168.203.155', '192.168.203.156', '192.168.203.157'] 
PE1 = '192.168.203.155'
P1 = '192.168.203.156'
PE2 = '192.168.203.157'
user = 'vyatta'
pa = 'vyatta'
PE1_router_id = '1.1.1.1'
P1_router_id = '2.2.2.2'
PE2_router_id = '3.3.3.3'
PE1_dataplane_config = {'dp0s8':'10.1.1.1/24','dp0s10':'20.1.1.1/24'}
PE1_loopback_config = {'lo':'1.1.1.1/32'}
PE1_ospf_config = {'0':['1.1.1.1/32','10.1.1.0/24','20.1.1.0/24']}
PE1_mpls_config = {'discovery':'dp0s10','tr':'1.1.1.1','lsr':'1.1.1.1'}
P1_dataplane_config = {'dp0s11':'30.1.1.2/24','dp0s10':'20.1.1.2/24'}
P1_loopback_config = {'lo':'2.2.2.2/32'}
P1_ospf_config = {'0':['2.2.2.2/32','20.1.1.0/24','30.1.1.0/24']}
P1_mpls_config = {'discovery1':'dp0s11','discovery2':'dp0s10','tr':'2.2.2.2','lsr':'2.2.2.2'}
PE2_dataplane_config = {'dp0s3':'172.16.1.1/24','dp0s11':'30.1.1.1/24'}
PE2_loopback_config = {'lo':'3.3.3.3/32'}
PE2_ospf_config = {'0':['3.3.3.3/32','172.16.1.0/24','30.1.1.0/24']}
PE2_mpls_config = {'discovery':'dp0s11','tr':'3.3.3.3','lsr':'3.3.3.3'}
Del_cmd = ['DELETE_MPLS','DELETE_OSPF','DELETE_INTERFACES']
PE1_pingcheck = ['20.1.1.2', '30.1.1.2', '30.1.1.1']
P1_pingcheck = ['20.1.1.1', '30.1.1.1']
PE2_pingcheck = ['30.1.1.2', '20.1.1.2', '20.1.1.1']
PE1_e2e_pingcheck_ip = '172.16.1.1'
PE2_e2e_pingcheck_ip = '10.1.1.1'
PE1_binding_chk = 'ipv4 1.1.1.1/32           2.2.2.2         imp-null'
P1_binding_chk1 = 'ipv4 2.2.2.2/32           1.1.1.1         imp-null'
P1_binding_chk2 = 'ipv4 2.2.2.2/32           3.3.3.3         imp-null'
PE2_binding_chk = 'ipv4 3.3.3.3/32           2.2.2.2         imp-null'
