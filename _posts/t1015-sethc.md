---
layout: post
title: "t1015 sethc"
date: 2024-06-18
categories: persistence
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /persistence/
---

---
description: Sticky keys backdoor.
---

# Sticky Keys

## Execution

Replace the originali sethc.exe with a cmd.exe and rename it. You may need to change sethc.exe owner to yourself first as TrustedIntaller may be giving you a hard time:

![](../../.gitbook/assets/sethc-trustedinstaller.png)

![](../../.gitbook/assets/sethc-backdoor.png)

Hit shift 5 times while on the logon screen to invoke the backdoor:

![](<../../.gitbook/assets/sethc-logon (1).png>)

## Observations

If you notice sethc.exe spawning well known windows processes, you may want to investigate the endpoint further:

![](../../.gitbook/assets/sethc-enumeration.png)
@spotheplanet
