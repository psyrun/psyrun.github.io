---
layout: post
title: "t1096 alternate data streams"
date: 2024-06-18
categories: defense-evasion
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /defense-evasion/
---

# Alternate Data Streams

## Execution

Creating a benign text file:

{% code title="attacker@victim" %}
```csharp
echo "this is benign" > benign.txt
Get-ChildItem
```
{% endcode %}

![](../../.gitbook/assets/ads-benign.png)

![](broken-reference)

Hiding an `evil.txt` file inside the `benign.txt`

{% code title="attacker@victim" %}
```csharp
cmd '/c echo "this is evil" > benign.txt:evil.txt'
```
{% endcode %}

![](../../.gitbook/assets/ads-evil.png)

![](broken-reference)

Note how the evil.txt file is not visible through the explorer - that is because it is in the alternate data stream now. Opening the benign.txt shows no signs of evil.txt. However, the data from evil.txt can still be accessed as shown below in the commandline - `type benign.txt:evil.txt`:

![](../../.gitbook/assets/ads-evil-2.png)

Additionally, we can view the data in the notepad as well by issuing:

{% code title="attacker@victim" %}
```csharp
notepad .\benign.txt:evil.txt
```
{% endcode %}

![](../../.gitbook/assets/ads-evil3.png)

## Observations

![](../../.gitbook/assets/ads-commandline.png)

Note that powershell can also help finding alternate data streams:

```csharp
Get-Item c:\experiment\evil.txt -Stream *
Get-Content .\benign.txt -Stream evil.txt
```

![](../../.gitbook/assets/ads-powershell.png)

## References

{% embed url="https://attack.mitre.org/wiki/Technique/T1096" %}

{% embed url="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/providers/filesystem-provider/get-item-for-filesystem?view=powershell-6" %}

{% embed url="https://blog.malwarebytes.com/101/2015/07/introduction-to-alternate-data-streams/" %}
@spotheplanet