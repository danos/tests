Copyright (c) 2020-2021, Happiest Minds Technologies Limited Intellectual Property. All rights reserved.

SPDX-License-Identifier: LGPL-2.1-only

# Test Automation Framework. This section is divided in to 3 parts:
  **a)	Automation Framework structure**
  
  **b)	Installation procedure**
  
  **c)	Test script execution procedure**

# a) Automation framework structure:

   **README.md**   :- This file
   
   **script**   :- Contains main test scripts. Test scripts can be added in this directory
   
   **keyword**  :- Contains keywords which are required for test scripts. Keywords can be re-used for scripts and new keywords can be added to this directory
   
   **library**  :- Contains python supporting library functions which are required for different command execution and it can be re-used for different test scripts
   
   **variable** :- Contains variables required for test scripts
   
   **testdata** :- Contains test data required for the test script execution. User has to modify the respective test data file under this directory based on the topology created, before execution of test script
   

# b) Installation procedure:

   1. Install following packages on the automation server (ubuntu-18.04). Refer: https://robotframework.org/
   
      _sudo apt-get update_
      
      _pip install python3_
      
      _sudo pip install robotframework_
      
      _sudo pip install robotframework-sshlibrary_
      
      _pip install vymgmt_


   2. Get the latest automation scripts to automation server from here:
   
      _git clone https://github.com/danos/tests.git_

# c) Test script execution procedure:

#####    Procedure for IPSec VPN test scenario ##### ========>>

  1. Bring up the test setup with DANOS as per the topology and follow remaining steps.
  
     For building IPSec VPN topology refer following link:-
   
     https://danosproject.atlassian.net/wiki/spaces/DAN/pages/2883615/Example+setting+up+site-to-site+VPN+using+IPsec

  2. Update following file with the correct information of mgmt. IP, interface name, interface IPs
  
     _testdata/IPSEC_VPN_DANOS_testdata.robot_

  3. Examples on how to execute test script:
   
     _cd script_
     
     Example1: Execute script and store result in current directory
   
     _robot IPSEC_VPN_DANOS.robot_
      
     Example2: Execute script and store result in specified directory
   
     _robot --outputdir ../result IPSEC_VPN_DANOS.robot_
     
     Example3: Pass parameters in command-line and execute script
   
     _python -m robot.run --variable R1:192.168.203.155 --variable R2:192.168.203.156 --variable R3:192.168.203.157 IPSEC_VPN_DANOS.robot_
     
     Example4: To generate report with specific name
   
     _robot --report=IPSEC_VPN_report.html --log=IPSEC_VPN_log.html --output=IPSEC_VPN_output.xml IPSEC_VPN_DANOS.robot_

  4. To view test results in HTML from any of the browser (ex. firefox)
  
     _cd result_
     
     _firefox report.html_

#####    Procedure for MPLS-LDP test scenario ##### ========>>

  1. Bring up the test setup with DANOS as per the topology and follow remaining steps.
  
     For building MPLS-LDP topology refer following link:-
   
     https://danosproject.atlassian.net/wiki/spaces/DAN/pages/370409495/Example+setting+up+MPLS-LDP

  2. Update following file with the correct information of mgmt. IP, interface name, interface IPs
  
     _testdata/MPLS_LDP_DANOS_testdata.robot_

  3. Examples on how to execute test script:
  
     _cd script_
     
     Example1: Execute script and store result in current directory
   
     _robot MPLS_LDP_DANOS.robot_
     
     Example2: Execute script and store result in specified directory
   
     _robot --outputdir ../result MPLS_LDP_DANOS.robot_
     
     Example3: Pass parameters in command-line and execute script
   
     _python -m robot.run --variable PE1:192.168.203.155 --variable P1:192.168.203.156 --variable PE2:192.168.203.157 MPLS_LDP_DANOS.robot_
     
     Example4: To generate report with specific name
   
     _robot --report=MPLS_LDP_report.html --log=MPLS_LDP_log.html --output=MPLS_LDP_output.xml MPLS_LDP_DANOS.robot_

  4. To view test results in HTML from any of the browser (ex. firefox)
  
     _cd result_
     
     _firefox report.html_

#####    Procedure for BGP test scenario ##### ========>>

  1. Bring up the test setup with DANOS as per the topology and follow remaining steps.
  

  2. Update following file with the correct information of mgmt. IP, interface name, interface IPs
  
     _testdata/BGP_DANOS_testdata.robot_

  3. Example on how to execute test script:
  
     _cd script_
     
     _python -m robot BGP_DANOS.robot_
     
  4. To view test results in HTML from any of the browser (ex. firefox)
  
     _cd script_
     
     _firefox report.html_
