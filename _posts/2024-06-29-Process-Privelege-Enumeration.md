---
layout: post
title: "Windows Process Free Memory and Privelege Enumeration"
date: 2024-06-29
categories: Windows-Reverse-Shell
tags: redteam, mitre, killchain, cpent, LPT, cpts, oscp, exploit
permalink: /process-privelege-enumeration/
---
# Exploring Free Memory Regions in Windows Processes

When analyzing software vulnerabilities, it's crucial to understand the memory layout of a process. One aspect of this is identifying free memory regions, which can be exploited by attackers to execute arbitrary code. In this blog post, we'll explore a program written in C that lists all processes running on a Windows system and identifies their free memory regions with respective permissions which is lastly saved in csv file.

## Understanding the Code

### Include Statements
```c
#include <windows.h>
#include <tlhelp32.h>
#include <tchar.h>
#include <stdio.h>
```

These are standard C and Windows API headers necessary for the program's functionality.

### Helper Function: `ProtectionToString`
```c
const TCHAR* ProtectionToString(DWORD protect) {
    // Function to get a string representation of the memory protection flags
    switch (protect) {
        // Cases for different protection types
        // (e.g., PAGE_READONLY, PAGE_READWRITE)
        default: return _T("Unknown");
    }
}
```

This function converts the memory protection flags returned by the Windows API into human-readable strings. These flags describe the access rights for a memory region (e.g., read, write, execute).

### Helper Function: `FindFreeMemoryRegions`
```c
void FindFreeMemoryRegions(FILE* fp, DWORD processID) {
    // Function to find and store free memory regions in a given process
    // Opens the process with required access rights
    // Loops through all memory regions and prints information about free regions
}
```

This function finds and stores information about free memory regions in a given process. It opens the process using `OpenProcess`, loops through all memory regions using `VirtualQueryEx`, and prints information about free regions to a specified file.

### Main Function: `ListProcessesAndFindFreeMemoryRegions`
```c
void ListProcessesAndFindFreeMemoryRegions() {
    // Function to list all processes and find free memory regions
    // Opens a file for writing output
    // Takes a snapshot of all processes in the system
    // Retrieves information about each process and calls FindFreeMemoryRegions
}
```

This function lists all processes running on the system, opens a file for writing output, and then retrieves information about each process using `CreateToolhelp32Snapshot` and `Process32First/Process32Next`. For each process, it calls `FindFreeMemoryRegions` to identify and store information about free memory regions.

### Entry Point: `main`
```c
int main(void) {
    // Entry point of the program
    ListProcessesAndFindFreeMemoryRegions();
    return 0;
}
```

## Running the Program

To run the program, compile it using a C compiler (e.g., GCC) and execute the generated executable. The program will list all processes running on the system and identify their free memory regions, storing the information in a CSV file named `free_memory_regions.csv`.


```cpp
#include <windows.h>
#include <tlhelp32.h>
#include <tchar.h>
#include <stdio.h>

// Function to get a string representation of the memory protection flags
const TCHAR* ProtectionToString(DWORD protect) {
    switch (protect) {
        case PAGE_NOACCESS:          return _T("No Access");
        case PAGE_READONLY:          return _T("Read-Only");
        case PAGE_READWRITE:         return _T("Read/Write");
        case PAGE_WRITECOPY:         return _T("Write Copy");
        case PAGE_EXECUTE:           return _T("Execute");
        case PAGE_EXECUTE_READ:      return _T("Execute/Read");
        case PAGE_EXECUTE_READWRITE: return _T("Execute/Read/Write");
        case PAGE_EXECUTE_WRITECOPY: return _T("Execute/Write Copy");
        case PAGE_GUARD:             return _T("Guard Page");
        case PAGE_NOCACHE:           return _T("No Cache");
        case PAGE_WRITECOMBINE:      return _T("Write Combine");
        default:                     return _T("Unknown");
    }
}

// Function to find and store free memory regions in a given process
void FindFreeMemoryRegions(FILE* fp, DWORD processID) {
    HANDLE hProcess;
    MEMORY_BASIC_INFORMATION mbi;
    LPVOID address = NULL;
    SIZE_T result;

    // Open the process with required access rights
    hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, processID);
    if (hProcess == NULL) {
        _tprintf(_T("Could not open process with PID %u. Error: %u\n"), processID, GetLastError());
        return;
    }

    // Loop through all memory regions
    while (address < (LPVOID)0x7FFFFFFF && 
           (result = VirtualQueryEx(hProcess, address, &mbi, sizeof(mbi))) != 0) {
        if (mbi.State == MEM_FREE) {
            _ftprintf(fp, _T("%u,0x%p,0x%zx,%s\n"), 
                      processID, mbi.BaseAddress, mbi.RegionSize, ProtectionToString(mbi.Protect));
        }
        address = (LPVOID)((DWORD_PTR)mbi.BaseAddress + mbi.RegionSize);
    }

    CloseHandle(hProcess);
}

// Function to list all processes and find free memory regions
void ListProcessesAndFindFreeMemoryRegions() {
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;

    FILE* fp = _tfopen(_T("free_memory_regions.csv"), _T("w"));
    if (fp == NULL) {
        _tprintf(_T("Failed to open output file.\n"));
        return;
    }

    // Write CSV header
    _ftprintf(fp, _T("PID,BaseAddress,RegionSize,Protection\n"));

    // Take a snapshot of all processes in the system.
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE) {
        _tprintf(_T("CreateToolhelp32Snapshot (of processes) failed.\n"));
        fclose(fp);
        return;
    }

    // Set the size of the structure before using it.
    pe32.dwSize = sizeof(PROCESSENTRY32);

    // Retrieve information about the first process,
    // and exit if unsuccessful.
    if (!Process32First(hProcessSnap, &pe32)) {
        _tprintf(_T("Process32First failed.\n")); // Show cause of failure
        CloseHandle(hProcessSnap);               // Clean the snapshot object
        fclose(fp);
        return;
    }

    // Now walk the snapshot of processes, and find free memory regions for each process.
    do {
        _tprintf(_T("Processing PID: %u (%s)\n"), pe32.th32ProcessID, pe32.szExeFile);
        FindFreeMemoryRegions(fp, pe32.th32ProcessID);
    } while (Process32Next(hProcessSnap, &pe32));

    CloseHandle(hProcessSnap);
    fclose(fp);
}

int main(void) {
    ListProcessesAndFindFreeMemoryRegions();
    return 0;
}

```
**How to Compile and Run**
Compile: Save the code in a file named `find_free_memory_all.cpp`. Use a compiler like MinGW or MSVC to compile the code:

- Using MinGW: `gcc -o find_free_memory_all.exe find_free_memory_all.cpp`
- Using MSVC: Open Developer Command Prompt and use `cl /EHsc find_free_memory_all.cpp`

Run: Execute the compiled program:

- `find_free_memory_all.exe`

**Explanation:**
- `ProtectionToString`: Converts the memory protection flags to a human-readable string.
- `FindFreeMemoryRegions`: Finds and stores free memory regions of a given process in the CSV file.
- `ListProcessesAndFindFreeMemoryRegions`: Takes a snapshot of all processes, iterates through each process, and calls `FindFreeMemoryRegions` to find and store the free memory regions for each process.

The program creates a CSV file named `free_memory_regions.csv` with the following columns:

- `PID`: The process ID.
- `BaseAddress`: The base address of the free memory region.
- `RegionSize`: The size of the free memory region.
- `Protection`: The protection attribute of the memory region.

This way, the program will iterate through all processes, find free memory regions, and store the results in a CSV file.


## Conclusion

Understanding the memory layout of a process is crucial for vulnerability researchers. This program provides a starting point for exploring memory regions in Windows processes, which can help identify potential vulnerabilities and improve overall system security.


### Source 
https://github.com/psyrun/Process-Privelege-Enumeration.git

#peacout #opensource


