#!/usr/bin/python3
# * Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.
# *
# * SPDX-License-Identifier: LGPL-2.1-only
import time
import vymgmt

def config_set(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    handle.set(cmd)
    handle.commit()
    handle.save()
    handle.exit()
    handle.logout()

def config_show_service(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    out = handle.run_conf_mode_command(cmd)
    handle.exit()
    handle.logout()
    output = out.split("\n")
    output2 = ''.join([str(elem) for elem in output])
    return output2

def config_delete(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    handle.delete(cmd)
    handle.commit()
    handle.save()
    handle.exit()
    handle.logout()

def show_command(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    out = handle.run_op_mode_command(cmd)
    handle.exit()
    handle.logout()
    output = out.split("\n")
    #output2 = ''.join([str(elem) for elem in output])
    return output

def config_ipsecvpn(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    for line in cmd:
        print(line)
        handle.set(line)
    handle.commit()
    handle.save()
    handle.exit()
    handle.logout()

def config_mplsldp(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    for line in cmd:
        print(line)
        handle.set(line)
    handle.commit()
    handle.save()
    handle.exit()
    handle.logout()

def config(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    for line in cmd:
        print(line)
        handle.set(line)
    handle.commit()
    handle.save()
    handle.exit()
    handle.logout()

def apply_rule(ip, user, ps, iface, rule, cmd):
    command = cmd.replace('INTERFACE',iface).replace('RULE',rule)
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    handle.set(command)
    handle.commit()
    handle.save()
    handle.exit()
    handle.logout()

def delete_rule(ip, user, ps, iface, rule, cmd):
    command = cmd.replace('INTERFACE',iface).replace('RULE',rule)
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    handle.delete(command)
    handle.commit()
    handle.save()
    handle.exit()
    handle.logout()

def config_show_ipsecvpn(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    out = handle.run_conf_mode_command(cmd)
    handle.exit()
    handle.logout()
    output = out.split("\n")
    return output

def config_show_mplsldp(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    out = handle.run_conf_mode_command(cmd)
    handle.exit()
    handle.logout()
    output = out.split("\n")
    return output

def config_show(ip, user, ps, cmd):
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.configure()
    out = handle.run_conf_mode_command(cmd)
    handle.exit()
    handle.logout()
    output = out.split("\n")
    return output

def sendping(ip, user, ps, vpnip):
    c1='sudo killall -9 ping'
    cmd='sudo ping -c30 ' + vpnip + ' > /dev/null 2>&1 &'
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    handle.run_op_mode_command(c1)
    out = handle.run_op_mode_command(cmd)
    handle.exit()
    handle.logout()

def capture_traffic(ip, user, ps, iface):
    cmd='sudo timeout 5 tcpdump -i ' + iface
    handle = vymgmt.Router(ip, user, password=ps, port=22)
    handle.login()
    out = handle.run_op_mode_command(cmd)
    handle.exit()
    handle.logout()
    output = out.split("\n")
    return output

def pr(st):
    for line in st:
        print(line)
