#!/usr/bin/python
import getpass
import paramiko
import time
#import xmltodict

#Set var
message = 100
firstcon = 1
ans = '1'
count = 0

#Set standard messages
CAPABILITIES = """
<?xml version="1.0" encoding="UTF-8"?>
  <hello xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
    <capabilities>
      <capability>urn:ietf:params:netconf:base:1.0</capability>
      <capability>urn:ietf:params:netconf:capability:writable-running:1.0</capability>
      <capability>urn:ietf:params:netconf:capability:candidate:1.0</capability>
      <capability>urn:ietf:params:netconf:capability:startup:1.0</capability>
      <capability>urn:ietf:params:netconf:capability:rollback-on-error:1.0</capability>
    </capabilities>
  </hello>
  ]]>]]> 
"""

IMAGE = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="1">
<get>
  <filter type="subtree">
    <image-v1:system-image xmlns:image-v1="urn:vyatta.com:mgmt:vyatta-image:1"/>
  </filter>
</get>
</rpc>]]>]]>
"""

PINGD = """
<rpc message-id="r_msg" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
	<ping xmlns="urn:vyatta.com:mgmt:vyatta-op:1">
		<host>r_dst</host>
		<count>r_cnt</count>
		<ttl>3</ttl>
	</ping>
</rpc>
]]>]]>
"""

CLOSE ="""
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
<close-session/>
</rpc>
]]>]]>
"""

ROUTEINFO = """
<rpc message-id="101" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
        <route xmlns="urn:vyatta.com:mgmt:vyatta-op:1">
        </route>
</rpc>
]]>]]>
"""

INTERFACES="""
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="1">
<get>
  <filter type="subtree">
    <vyatta-if-v1:interfaces xmlns:vyatta-if-v1="urn:vyatta.com:mgmt:vyatta-interfaces:1"/>
  </filter>
</get>
</rpc>]]>]]>
"""

INTERFACEINFO = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="101">
<interface xmlns="urn:vyatta.com:mgmt:vyatta-op:1">
    <name>INTERFACE_NAME</name>
</interface>
</rpc>]]>]]>
"""

CPUINFO="""
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="1">
    <get xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
        <filter type="subtree">
            <system>
                <state>
                    <processor xmlns="urn:vyatta.com:mgmt:vyatta-system:1">
                    </processor>
                </state>
            </system>
        </filter>
    </get>
</rpc>]]>]]>
"""

UPTIMEINFO = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="1">
    <get xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
        <filter type="subtree">
            <system>
                <state>
                    <times xmlns="urn:vyatta.com:mgmt:vyatta-system:1">
                    </times>
                </state>
            </system>
        </filter>
    </get>
</rpc>]]>]]>
"""

MEMORYINFO = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="1">
    <get xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
        <filter type="subtree">
            <system>
                <state>
                    <memory xmlns="urn:vyatta.com:mgmt:vyatta-system:1">
                    </memory>
                </state>
            </system>
        </filter>
    </get>
</rpc>]]>]]>
"""

RUNNINGCONFIG = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="">
  <get-config>
    <source>
      <running/>
    </source>
  </get-config>
</rpc>]]>]]>
"""

CONFIGURE_INTERFACE = """
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

EDIT_INTERFACE = """
<rpc xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="3">
    <edit-config>
        <target>
            <candidate/>
        </target>
        <config xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:xc="urn:ietf:params:xml:ns:netconf:base:1.0">
            <interfaces xmlns="urn:vyatta.com:mgmt:vyatta-interfaces:1">
                <dataplane xmlns="urn:vyatta.com:mgmt:vyatta-interfaces-dataplane:1">
                    <tagnode xmlns="urn:vyatta.com:mgmt:vyatta-interfaces-dataplane:1">INTERFACE</tagnode>
                    <description>DESCRIPTION</description>
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

hostname = '192.168.203.156'
username = 'vyatta'
password = 'vyatta'
port     = 830

ssh = paramiko.SSHClient()

def close_netconf_session(ncsession):
    ncsession.close()

def close_ssh(ssh):
    ssh.close()

def get_netconf_session(hostname, username, password, port):

    #ignore missing hostkey
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname, username=username,password=password, port=830)

    #get transport from previous ssh connection
    trans = ssh.get_transport()

    #create channel for netconf
    chan = trans.open_session()
    name = chan.set_name('netconf')
    chan.invoke_subsystem('netconf')
    #data = chan.recv(131072)
    data = chan.recv(8192)
    #data = chan.recv(12288)
    time.sleep(10)
    chan.send(CAPABILITIES)
    data = chan.recv(2048)
    return chan

def ping(ip, u, p, destip, cnt, image_req):
    chan = get_netconf_session(ip, u, p, 830)
    message = 100
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue

        PING_T = image_req.replace('r_dst',destip).replace('r_msg',str(message+1)).replace('r_cnt',str(cnt))
        message = message + 1
        chan.send(PING_T)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def get(ip, u, p, image_req):
    chan = get_netconf_session(ip, u, p, 830)
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue
        chan.send(image_req)
        #data1 = chan.recv(4096)
        #print("image reply data1:",data1)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def config_interface(ip, u, p, iface, address, image_req):
    chan = get_netconf_session(ip, u, p, 830)
    #message = 102
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue

        CONFIG = image_req.replace('INTERFACE',iface).replace('ADDRESS',str(address))
        chan.send(CONFIG)
        time.sleep(1)
        chan.send(COMMIT)
        time.sleep(5)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def edit_interface(ip, u, p, iface, pattern, image_req):
    chan = get_netconf_session(ip, u, p, 830)
    #message = 102
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue

        CONFIG = image_req.replace('INTERFACE',iface).replace('DESCRIPTION',str(pattern))
        chan.send(CONFIG)
        time.sleep(1)
        chan.send(COMMIT)
        time.sleep(5)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def get_interface_info(ip, u, p, iface, image_req):
    chan = get_netconf_session(ip, u, p, 830)
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue

        request = image_req.replace('INTERFACE_NAME',iface)
        chan.send(request)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def print_output(strings):
    for line in strings:
        print(line)

def config_interfaces(ip, u, p, data, image_req):
    chan = get_netconf_session(ip, u, p, 830)
    #message = 102
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue
        for iface, address in data.items():
            print("iface, address",iface, address)
            CONFIG = image_req.replace('INTERFACE',iface).replace('ADDRESS',str(address))
            print("CONFIG_interfaces:",CONFIG)
            chan.send(CONFIG)
            time.sleep(1)
        chan.send(COMMIT)
        time.sleep(5)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def show_cmd(ip, u, p, cmd, template):
    chan = get_netconf_session(ip, u, p, 830)
    #message = 102
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue

        CONFIG = template.replace('CMD',cmd)
        chan.send(CONFIG)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output
    
def config_ospf(ip, u, p, data, template):
    chan = get_netconf_session(ip, u, p, 830)
    #message = 102
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(2)
            continue

        for area,val in data.items():
            for addr in val:
                CONFIG = template.replace('AREA_ID',str(area)).replace('ADDRESS',str(addr))
                time.sleep(1)
                chan.send(CONFIG)
                time.sleep(1)
        chan.send(COMMIT)
        time.sleep(5)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def config_mpls_ldp_addr_family_edge(ip, u, p, data, template):
    chan = get_netconf_session(ip, u, p, 830)
    #message = 102
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue

        CONFIG = template.replace('DIS_IFACE',data['discovery']).replace('TR_ID',data['tr'])\
                 .replace('LSR_ID',data['lsr'])
        chan.send(CONFIG)
        time.sleep(1)
        chan.send(COMMIT)
        time.sleep(5)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def config_mpls_ldp_addr_family_core(ip, u, p, data, template):
    chan = get_netconf_session(ip, u, p, 830)
    #message = 102
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            chan.recv(4096)
            time.sleep(1)
            continue

        CONFIG = template.replace('DIS_IFACE1',data['discovery1']).replace('TR_ID',data['tr'])\
                .replace('DIS_IFACE2',data['discovery2']).replace('LSR_ID',data['lsr'])
        chan.send(CONFIG)
        time.sleep(1)
        chan.send(COMMIT)
        time.sleep(5)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output

def del_cmd(ip, u, p, *args):
    chan = get_netconf_session(ip, u, p, 830)
    #message = 102
    while not chan.exit_status_ready():
        chan.recv(4096)
        # Buffer data is true
        if chan.recv_ready():
            chan.send(CAPABILITIES)
            data=chan.recv(4096)
            time.sleep(1)
            continue

        for cmd in args:
            CONFIG = cmd
            chan.send(CONFIG)
            time.sleep(1)
        chan.send(COMMIT)
        time.sleep(5)
        chan.send(CLOSE)
        data = str(chan.recv(2048))
        close_netconf_session(chan)
        output = data.split("\n")
        return output
