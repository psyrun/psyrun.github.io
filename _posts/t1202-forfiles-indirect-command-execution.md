---
layout: post
title: "t1202 forfiles indirect command execution"
date: 2024-06-18
categories: code-execution
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /code-execution/
---

---
description: Defense Evasion
---

# Forfiles Indirect Command Execution

This technique launches an executable without a cmd.exe.

## Execution

```csharp
forfiles /p c:\windows\system32 /m notepad.exe /c calc.exe
```

![](../../.gitbook/assets/forfiles-executed.png)

## Observations

Defenders can monitor for process creation/commandline logs to detect this activity:

![](../../.gitbook/assets/forfiles-ancestry.png)

![](../../.gitbook/assets/forfiles-cmdline.png)

## References

{% embed url="https://attack.mitre.org/wiki/Technique/T1202" %}
@spotheplanet