# File System Feature Study

Tracing syscall coverage for `nginx`, `sqlite`, and `mysql` applications with different infrastructure settings on a Linux server.

- `tracings`: Contains both `ebpf` and `lttng` scripts for tracing.
- `workloads`: Customized applications to trigger target applications functions for syscall coverage analysis.
- `old-configs`: Don't use. Instead use the `ansible` playbook in the `infra/` directory.
