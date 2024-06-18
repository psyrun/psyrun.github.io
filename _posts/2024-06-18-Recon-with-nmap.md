---
layout: post
title: "2024-06-18-64 Recon with psymap-nmap.py"
date: 2024-06-18
categories: Reconnaissance | Enumeration
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /Recon-with-nmap/
---
# Understanding Nmap Commands for Network Scanning

Nmap (Network Mapper) is a powerful open-source tool used for network exploration and security auditing. It works by sending packets to target hosts and analyzing the responses to determine various aspects of the network, such as open ports, operating systems, and services running on the hosts.

In this blog post, we will explore various Nmap commands and how they can be used for network scanning.

## Regular Scan

Regular scans are the basic scans performed to gather information about a target network. They are generally non-intrusive and provide essential insights into the network topology.

- **TCP SYN Scan:** `sudo nmap -sS TARGET`
- **TCP Connect Scan:** `sudo nmap -sT TARGET`
- **Ping Scan:** `nmap -sn TARGET`

## Intensive Scan

Intensive scans are more thorough and may involve multiple scan techniques to gather detailed information about the target network.

- **TCP SYN Scan:** `sudo nmap -sS TARGET`
- **TCP Connect Scan:** `sudo nmap -sT TARGET`
- **UDP and TCP SYN Scan:** `sudo nmap -sU -sS TARGET`
- **Ping Sweep Scan:** `nmap -sn TARGET`
- **Verbose Ping Sweep Scan with Output to File:** `nmap -v -sn TARGET -oG ping-sweep.txt`
- **Extracting Open Ports from Ping Sweep Output:** `grep open web-sweep.txt | cut -d' ' -f2`
- **Top Port Sweep Scan:** `nmap -sT -A --top-ports=20 TARGET -oG top-port-sweep.txt`
- **Operating System Detection:** `sudo nmap -O TARGET --osscan-guess`
- **Aggressive Scan:** `nmap -sT -A TARGET`
- **HTTP Headers Script Scan:** `nmap --script http-headers TARGET`
- **HTTP Headers Script Help:** `nmap --script-help http-headers`
- **SMB Scan:** `nmap -v -p 139,445 -oG smb.txt TARGET`
- **SMB OS Discovery Scan:** `nmap -v -p 139,445 --script smb-os-discovery TARGET`
- **Open SNMP Scan:** `sudo nmap -sU --open -p 161 TARGET -oG open-snmp.txt`

## Full Scan

Full scans are comprehensive scans that leave no stone unturned in analyzing the target network's structure and services.

- **TCP SYN Scan:** `sudo nmap -sS TARGET`
- **TCP Connect Scan:** `sudo nmap -sT TARGET`
- **UDP and TCP SYN Scan:** `sudo nmap -sU -sS TARGET`
- **Ping Scan:** `nmap -sn TARGET`
- **Verbose Ping Sweep Scan:** `nmap -v -sn TARGET -oG ping-sweep.txt`
- **Extracting Open Ports from Ping Sweep Output:** `grep open sweet-sweep.txt | cut -d' ' -f2`
- **Top Port Sweep Scan:** `nmap -sT -A --top-ports=20 TARGET -oG top-port-sweep.txt`
- **Operating System Detection:** `sudo nmap -O TARGET --osscan-guess`
- **Aggressive Scan:** `nmap -sT -A TARGET`
- **HTTP Headers Script Scan:** `nmap --script http-headers TARGET`
- **HTTP Headers Script Help:** `nmap --script-help http-headers`
- **SMB Scan:** `nmap -v -p 139,445 -oG smb.txt TARGET`
- **SMB OS Discovery Scan:** `nmap -v -p 139,445 --script smb-os-discovery TARGET`
- **Open SNMP Scan:** `sudo nmap -sU --open -p 161 TARGET -oG open-snmp.txt`
- **Kerberos Enumeration:** `nmap TARGET -p 88 --script krb5-enum-users --script-args krb5-enum-users.realm='test'`


here is the python program which will fully recon your target with the above mindmap..
```python
import argparse
import subprocess
import os

def run_nmap(command, output_dir):
    try:
        subprocess.run(f"{command} -oN {output_dir}/output.txt", shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")

def main():
    parser = argparse.ArgumentParser(description="Run Nmap scans")
    parser.add_argument("target", help="IP address or domain name to scan")
    parser.add_argument("-t", "--type", choices=["regular", "intensive", "full"], default="regular",
                        help="Specify the scan type (regular, intensive, or full)")
    args = parser.parse_args()

    output_dir = f"{args.target}_output"
    os.makedirs(output_dir, exist_ok=True)

    if args.type == "regular":
        run_nmap(f"sudo nmap -sS -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -sT -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap -sn -T4 -Pn {args.target}", output_dir)
    elif args.type == "intensive":
        run_nmap(f"sudo nmap -sS -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -sT -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -sU -sS -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap -sn -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap -v -sn -T4 -Pn {args.target} -oG {output_dir}/ping-sweep.txt", output_dir)
        run_nmap(f"grep open {output_dir}/web-sweep.txt | cut -d' ' -f2", output_dir)
        run_nmap(f"nmap -sT -A --top-ports=20 -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -O -T4 -Pn {args.target} --osscan-guess", output_dir)
        run_nmap(f"nmap -sT -A -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap --script http-headers -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap --script-help http-headers", output_dir)
        run_nmap(f"nmap -v -p 139,445 -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap -v -p 139,445 --script smb-os-discovery -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -sU --open -p 161 -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap --script ssh-hostkey* -T4 -Pn {args.target}", output_dir)
    elif args.type == "full":
        run_nmap(f"sudo nmap -sS -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -sT -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -sU -sS -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap -sn -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap -v -sn -T4 -Pn {args.target} -oG {output_dir}/ping-sweep.txt", output_dir)
        run_nmap(f"grep open {output_dir}/web-sweep.txt | cut -d' ' -f2", output_dir)
        run_nmap(f"nmap -sT -A --top-ports=20 -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -O -T4 -Pn {args.target} --osscan-guess", output_dir)
        run_nmap(f"nmap -sT -A -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap --script http-headers -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap --script-help http-headers", output_dir)
        run_nmap(f"nmap -v -p 139,445 -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap -v -p 139,445 --script smb-os-discovery -T4 -Pn {args.target}", output_dir)
        run_nmap(f"sudo nmap -sU --open -p 161 -T4 -Pn {args.target}", output_dir)
        run_nmap(f"nmap --script ssh-hostkey* -T4 -Pn {args.target}", output_dir)
    else:
        print("Invalid scan type. Please choose 'regular', 'intensive', or 'full'.")

if __name__ == "__main__":
    main()
```
## Usage
```sh
python nmap_scan.py 192.168.50.149 -t regular
python nmap_scan.py 192.168.50.149 -t intensive
python nmap_scan.py 192.168.50.149 -t full
```


We have covered a range of Nmap commands for different types of network scans. Each command serves a specific purpose and can be used to gather valuable information about the target network.

### Git Repo
[github.com/psyrun/psymap.py](https://github.com/psyrun/psymap.py) 



