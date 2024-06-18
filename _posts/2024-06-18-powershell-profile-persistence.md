---
layout: post
title: "2024-06-18-powershell profile persistence"
date: 2024-06-18
categories: persistence
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /powershell-profile-persistence/
---

# Powershell Profile Persistence

It's possible to use powershell profiles for persistence and/or privilege escalation.

## Execution

There are four places you can abuse the powershell profile, depending on the privileges you have:

```csharp
$PROFILE | select *
```

![](<../../.gitbook/assets/image (219).png>)

Let's add the code to a `$profile` variable (that expands to the current user's profile file) that will get executed the next time the compromised user launches a powershell console:

{% code title="attacker@target" %}
```csharp
echo "whoami > c:\temp\whoami.txt" > $PROFILE
cat $PROFILE
```
{% endcode %}

![](<../../.gitbook/assets/image (215).png>)

Once the compromised user launches powershell, our code gets executed:

![](<../../.gitbook/assets/image (218).png>)

```
If the user is not using profiles, the technique will stick out immediately due to the "loading personal and system profiles..." message at the top.
```

## References

{% embed url="https://attack.mitre.org/techniques/T1504/" %}
@spotheplanet
