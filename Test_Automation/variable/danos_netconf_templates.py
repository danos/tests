#!/usr/bin/python3
# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only

validate_ospf_status = 'protocols ospf neighbor'
validate_mpls_ldp_neighbor = 'protocols mpls-ldp neighbor'
validate_mpls_ldp_ipv4_interface = 'protocols mpls-ldp ipv4 interface'
validate_mpls_ldp_ipv4_discovery = 'protocols mpls-ldp ipv4 discovery'
validate_mpls_ldp_ipv4_binding = 'protocols mpls-ldp ipv4 binding'
Del_cmd = ['DELETE_MPLS','DELETE_OSPF','DELETE_INTERFACES']

CONFIGURE_DATAPLANE = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="3">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <interfaces xmlns="urn:vyatta.com:mgmt:vyatta-interfaces:1">
                <dataplane xmlns="urn:vyatta.com:mgmt:vyatta-interfaces-dataplane:1">
                    <tagnode xmlns="urn:vyatta.com:mgmt:vyatta-interfaces-dataplane:1">INTERFACE</tagnode>
                    <address>ADDRESS</address>
                </dataplane>
            </interfaces>
        </config>
    </edit-config>
</rpc>]]>]]>
"""

COMMIT = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="1">
    <commit xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">\
    </commit>
</rpc>]]>]]>
"""

INTERFACEINFO = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="101">
<interface xmlns="urn:vyatta.com:mgmt:vyatta-op:1">
    <name>INTERFACE_NAME</name>
</interface>
</rpc>]]>]]>
"""

CONFIGURE_LOOPBACK = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="5">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <interfaces xmlns="urn:vyatta.com:mgmt:vyatta-interfaces:1">
                <loopback xmlns="urn:vyatta.com:mgmt:vyatta-interfaces-loopback:1">
                    <tagnode xmlns="urn:vyatta.com:mgmt:vyatta-interfaces-loopback:1">INTERFACE</tagnode>
                    <address>ADDRESS</address>
                </loopback>
            </interfaces>
        </config>
    </edit-config>
</rpc>]]>]]>
"""

CONFIGURE_OSPF = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="63">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <protocols xmlns="urn:vyatta.com:mgmt:vyatta-protocols:1">
                <ospf xmlns="urn:vyatta.com:mgmt:vyatta-protocols-frr-ospf:1">
                        <area>
                                <tagnode xmlns="urn:vyatta.com:mgmt:vyatta-protocols-frr-ospf:1">AREA_ID</tagnode>
                                        <network>ADDRESS</network>
                        </area>
                </ospf>
            </protocols>
        </config>
    </edit-config>
</rpc>]]>]]>
"""

CONFIGURE_MPLS_LDP_AD_FAMILY_EDGE = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="65">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <protocols xmlns="urn:vyatta.com:mgmt:vyatta-protocols:1">
                <mpls-ldp xmlns="urn:vyatta.com:mgmt:vyatta-protocols-frr-ldp:1">
                        <lsr-id>LSR_ID</lsr-id>
                         <address-family>
                                <ipv4>
                                        <discovery>
                                                <interfaces>
                                                        <interface>
                                                                <interface>DIS_IFACE</interface>
                                                        </interface>
                                                </interfaces>
                                        </discovery>
                                        <label-policy>
                                                 <allocate>
                                                         <host-routes/>
                                                 </allocate>
                                        </label-policy>
                                        <transport-address>TR_ID</transport-address>
                                </ipv4>
                        </address-family>
                </mpls-ldp>
            </protocols>
        </config>
    </edit-config>
</rpc>]]>]]>
"""

CONFIGURE_MPLS_LDP_AD_FAMILY_CORE = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="65">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <protocols xmlns="urn:vyatta.com:mgmt:vyatta-protocols:1">
                <mpls-ldp xmlns="urn:vyatta.com:mgmt:vyatta-protocols-frr-ldp:1">
                        <lsr-id>LSR_ID</lsr-id>
                         <address-family>
                                <ipv4>
                                        <discovery>
                                                <interfaces>
                                                        <interface>
                                                                <interface>DIS_IFACE1</interface>
                                                        </interface>
                                                        <interface>
                                                                <interface>DIS_IFACE2</interface>
                                                        </interface>
                                                </interfaces>
                                        </discovery>
                                        <label-policy>
                                                 <allocate>
                                                         <host-routes/>
                                                 </allocate>
                                        </label-policy>
                                        <transport-address>TR_ID</transport-address>
                                </ipv4>
                        </address-family>
                </mpls-ldp>
            </protocols>
        </config>
    </edit-config>
</rpc>]]>]]>
"""

CONFIGURE_MPLS_LDP_LSR_ID = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="61">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <protocols xmlns="urn:vyatta.com:mgmt:vyatta-protocols:1">
                <mpls-ldp xmlns="urn:vyatta.com:mgmt:vyatta-protocols-frr-ldp:1">
                         <lsr-id>LSR_ID</lsr-id>
                </mpls-ldp>
            </protocols>
        </config>
    </edit-config>
</rpc>]]>]]>
"""

SHOW_CMD = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="119">
         <command xmlns="urn:vyatta.com:mgmt:vyatta-opd:1">
                <args>CMD</args>
        </command>
</rpc>]]>]]>
"""

PINGD = """
<rpc message-id="r_msg" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
        <ping xmlns="urn:vyatta.com:mgmt:vyatta-op:1">
                <host>r_dst</host>
                <count>r_cnt</count>
                <ttl>3</ttl>
        </ping>
</rpc>]]>]]>
"""

DELETE_INTERFACES = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="132">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
                <interfaces xmlns="urn:vyatta.com:mgmt:vyatta-interfaces:1" xc:operation="delete"/>
         </config>
       </edit-config>
</rpc>]]>]]>
"""

DELETE_INTERFACES_DATAPLANE = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="132">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
                <interfaces xmlns="urn:vyatta.com:mgmt:vyatta-interfaces:1" >
                  <dataplane xmlns="urn:vyatta.com:mgmt:vyatta-interfaces-dataplane:1" xc:operation="delete">
                  </dataplane>
                </interfaces>    
         </config>
       </edit-config>
</rpc>]]>]]>
"""

DELETE_LOOPBACK = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="5">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <interfaces xmlns="urn:vyatta.com:mgmt:vyatta-interfaces:1">
                <loopback xmlns="urn:vyatta.com:mgmt:vyatta-interfaces-loopback:1"  xc:operation="delete">
                </loopback>
            </interfaces>
        </config>
    </edit-config>
</rpc>]]>]]>
"""

DELETE_OSPF = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="201">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <protocols xmlns="urn:vyatta.com:mgmt:vyatta-protocols:1">
                <ospf xmlns="urn:vyatta.com:mgmt:vyatta-protocols-frr-ospf:1" xc:operation="delete"/>
            </protocols>
        </config>
    </edit-config>
</rpc>]]>]]>
"""

DELETE_MPLS = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="61">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <protocols xmlns="urn:vyatta.com:mgmt:vyatta-protocols:1">
                <mpls-ldp xmlns="urn:vyatta.com:mgmt:vyatta-protocols-frr-ldp:1" xc:operation="delete"/>
             </protocols>
        </config>
    </edit-config>
</rpc>]]>]]>
"""
