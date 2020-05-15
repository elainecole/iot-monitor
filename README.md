# IoT Network Canary Overview (INC) 
569S Final Project by Elaine Cole, Griffin Shaw, Jarek Millburg, Kaiye Yu, and Ighor Tavares

## Overview
For this project, we designed an application that is capable of monitoring and hardening a given network against Mirai-like botnets. Our final product stands out in that it detects vulnerable IoT devices within a network and alerts the user in real-time and also is run on a single device within the given network but capable of securing multiple IoT devices within the same network.

Our final project consists of two major components: one serves as a honeypot and notification system, and the other serves as a network security hardener. We explain the details of each component below, and further detail per file how our product works in a later section.

## Structure 
```
  /
  ├── main/                 # main script 
  ├── whiteWorm.sh/         # scans network for open SSH ports
  ├── emailTools.py/        # notification system: emails user
  ├── secureCreds.sh/       # prompts user to change default credentials 
  ├── ssh_change/           # automates process of changing default credentials
  ├── ssh_check.py/         # checks for brute force SSH connection attempts
  ├── password.txt/         # list of passwords to use to attempt to connect
  ├── username.txt/         # list of admins to use to attempt to connect

```
## Usage
`./main`
First, run the ​main​ script which then it will prompt to input the valid password related to the email that will be notified. Once the valid password is given, it will ask the user if they would like to check for any vulnerable devices in the network. If the user says “no”, the script will run the honeypot monitoring script. If the user says “yes” , the script will proceed to identify which devices contains open ssh port, and then run Ncrack to finally identify if any devices are vulnerable to default credentials.

Once Ncrack is finished, the script will once again prompt the user if they want to change the default password of the vulnerable devices. If the user chooses to change the password, they will be asked to input a new secure password.

The script will then automatically change the password of the vulnerable device and notice the user that it was successfully changed. Once finished, the monitoring script will start.

## Honeypot & Notification Tool
Our honeypot sits passively on the network and appears vulnerable to those that try to SSH into it. It listens for brute force connection attempts and tracks them in our own specified auth_log file. Then, if the number of attempts for a given IP address exceeds a user-set heuristic, an alert email is sent to the user’s specified email address.

## Network Security Hardener
Our network hardener seeks, on a specified network, devices with open ports that are not defended by non-default credentials and then offers to the user to change the default credentials to something more secure. It first scans for devices with open ports on the given network. Once open ports are detected, we use Ncrack, a network authentication cracking tool, to try and make a connection through the open port. If we are successful, then the user is given the option via command line to change the weak credentials, thereby “hardening” the network security.

To properly identify vulnerable devices in the network, first it was required to mapped out all the devices currently live in the network. This was accomplished by running a pingless Nmap scan to treat the range of IP as alive and only report the live devices the ones in which responds back. Once the scan is over, the Iot Network Canary (INC) will update its valid ARP table, and collect all the live devices in the network along with its MAC addresses, and create a list to perform a port scan on it. Nmap is again used to identify all devices which contains port 22 open (SSH protocol).

To simulate a similar brute force attack on the devices found on the network to have open ports like the Mirai Botnet, we utilize a tool developed by Nmap called Ncrack. This tool allows us to attempt brute force connection attempts to many different types of ports on multiple machines with one simple command. Ncrack also comes with its own library of default credentials to use to attempt to access these ports similar to the database of default credentials that Mirai uses when it attempts to connect to your devices. With Ncrack and its library of credentials we can check to see if any of the devices on the network with open ports are still using default credentials. If our attempt with Ncrack is successful then good chance the Mirai botnet would also crack it.

The process of prompting the user to change the vulnerable password of the devices, was accomplished using a shell library called ​expect​. It simply “expects” a prompt in which sends the input automatically. IoT Network Canary first asks the user if they would like to change the password of vulnerable devices. Then the ​expect​ script, automatically connects to the vulnerable device through an ssh session with the cracked credentials, and it changes the password. Once done, the script automatically closes the ssh connection. During the whole process, all the output is redirected to ​/dev/null​ so no log is maintained.

Below our diagram outlines the workflow of our IoT Network Canary (INC):
![Image of Workflow](https://github.com/elainecole/iot-monitor/media/writeup_diagram.png)
