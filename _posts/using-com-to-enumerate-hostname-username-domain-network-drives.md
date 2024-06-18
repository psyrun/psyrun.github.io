---
layout: post
title: "using com to enumerate hostname username domain network drives"
date: 2024-06-18
categories: enumeration-and-discovery
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /enumeration-and-discovery/
---

# Using COM to Enumerate Hostname, Username, Domain, Network Drives

At `Computer\HKEY_CLASSES_ROOT\CLSID\{093FF999-1EA0-4079-9525-9614C3504B74}` we have a **Windows Script Host Network Object** COM object which allows us to get details such as computer name, logged on user, etc:

![](<../../.gitbook/assets/Annotation 2019-06-18 222057.png>)

```csharp
$o = [activator]::CreateInstance([type]::GetTypeFromCLSID("093FF999-1EA0-4079-9525-9614C3504B74"))
```

Below are all the properties and methods exposed by the object:

```csharp
$o | gm
```

![](<../../.gitbook/assets/Annotation 2019-06-18 221846.png>)

Viewing username, domain, machine name, etc:

```
$o
```

![](<../../.gitbook/assets/Annotation 2019-06-18 221927.png>)

We can also see any network connected drives:

```
$o.EnumNetworkDrives()
```

![](<../../.gitbook/assets/Annotation 2019-06-18 221949.png>)

## Observations

Below shows what additional modules Powershell loads once the COM object is instantiated:

![](../../.gitbook/assets/loaded-dlls.gif)
@spotheplanet