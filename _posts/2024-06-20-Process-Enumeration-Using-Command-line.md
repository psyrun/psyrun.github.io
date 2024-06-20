---
layout: post
title: "Enumerating Running Processes in Windows for Vulnerability Research"
date: 2024-06-19
categories: Windows-Vulnerability-Research
tags: redteam, mitre, killchain, cpent, LPT, cpts, oscp, exploit
permalink: /go-revshell/
---

## Introduction
This blog discusses a simple C program for enumerating running processes in Windows using the Windows API and explains its relevance in vulnerability research. The program provides a foundation for analyzing running processes, which is crucial in identifying potential vulnerabilities in software and system configurations.

## Program Overview
The program uses the Windows API functions to take a snapshot of all processes in the system and then iterates through the list to retrieve information about each process. It prints the name and process ID of each running process.

## Relevance in Vulnerability Research
1. **Process Enumeration**: Understanding the running processes on a system is essential for vulnerability research. It helps researchers identify processes that may be vulnerable to exploitation or are running with elevated privileges.

2. **Memory Analysis**: While the program does not perform memory analysis, it lays the groundwork for accessing and analyzing process memory. This is crucial for discovering vulnerabilities such as buffer overflows or insecure memory handling.

3. **Privilege Escalation**: Process enumeration is often the first step in identifying vulnerabilities that can lead to privilege escalation. By understanding the running processes and their permissions, researchers can identify potential avenues for exploitation.

## Code
```cpp
#include <windows.h>
#include <tlhelp32.h>
#include <tchar.h>  // For _TCHAR and _tprintf
#include <stdio.h>  // For _tprintf

void ListProcesses() {
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;

    // Take a snapshot of all processes in the system.
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE) {
        _tprintf(_T("CreateToolhelp32Snapshot (of processes) failed.\n"));
        return;
    }

    // Set the size of the structure before using it.
    pe32.dwSize = sizeof(PROCESSENTRY32);

    // Retrieve information about the first process,
    // and exit if unsuccessful.
    if (!Process32First(hProcessSnap, &pe32)) {
        _tprintf(_T("Process32First failed.\n")); // Show cause of failure
        CloseHandle(hProcessSnap);               // Clean the snapshot object
        return;
    }

    // Now walk the snapshot of processes, and display information about each process in turn.
    do {
        _tprintf(_T("PROCESS NAME: %s  (PID: %u)\n"), pe32.szExeFile, pe32.th32ProcessID);
    } while (Process32Next(hProcessSnap, &pe32));

    CloseHandle(hProcessSnap);
}

int main(void) {
    ListProcesses();
    return 0;
}
```

## Compilation and Building
To compile the program, follow these steps:

1. **Compile**: Save the code in a file named `list_processes.c` or `list_processes.cpp`. Use a compiler like MinGW or MSVC to compile the code:
    - Using MinGW: `gcc -o list_processes.exe list_processes.c`
    - Using MSVC: Open Developer Command Prompt and use `cl /EHsc list_processes.cpp`

2. **Run**: Execute the compiled program:
    - `list_processes.exe`

## Conclusion
Enumerating running processes in Windows is a fundamental aspect of vulnerability research. This program provides a starting point for understanding process enumeration and can be expanded upon to perform more advanced analysis. Understanding the running processes on a system is crucial for identifying and mitigating potential security risks.


### Source 
https://github.com/psyrun/Windows-Process-Enumeration.git

#peacout #opensource


