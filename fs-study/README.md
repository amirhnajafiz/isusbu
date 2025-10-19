# File System Feature Study

Directories:

- `/docker-workloads`: Customized applications to use with docker to test the syscall coverage.
    - `/nginx`: A bash script to run a NginX container.
    - `/kafka`: A publisher and subscriber application.
    - `/redis`: A flask backend service that uses Redis as cache.
- `/ebpf`: bpftrace and BCC scripts to trace all syscalls in a Linux machine.
- `/lttng`: LTTng and log analysis scripts to trace all syscalls in a Linux machine.
