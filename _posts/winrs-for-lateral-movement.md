---
layout: post
title: "winrs for lateral movement"
date: 2024-06-18
categories: all_md_files
tags: redteam, mitre killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /winrs-for-lateral-movement/
---

---
layout: post
title: "winrs for lateral movement"
date: 2024-06-18
categories: lateral-movement
tags: redteam, mitre killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /winrs-for-lateral-movement/
---

# WinRS for Lateral Movement

It's possible to use a native Windows binary `winrs` to connect to a remote endpoint via `WinRM` like so:

```
winrs -r:ws01 "cmd /c hostname & notepad"
```

Below shows how we connect from `DC01` to `WS01` and execute two processes `hostname`,`notepad` and the process partent/child relationship for processes spawned by the `winrshost.exe`:

![](<../../.gitbook/assets/image (669).png>)

## References

{% embed url="https://bohops.com/2020/05/12/ws-management-com-another-approach-for-winrm-lateral-movement/amp/" %}
@spotheplanet
