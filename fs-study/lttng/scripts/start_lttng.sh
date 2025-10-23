#!/usr/bin/env sh

SESSION="all-syscalls-session"

# setup_lttng.sh
# This script sets up an LTTng tracing session for all system calls,
# including various context information, and stores the traces in /tmp/lttng-traces-100.

sudo lttng create syscalls-session-"${SESSION}" --output /tmp/lttng-traces-"${SESSION}"

sudo lttng add-context --kernel --type vpid
sudo lttng add-context --kernel --type vtid
sudo lttng add-context --kernel --type procname
sudo lttng add-context --kernel --type pid
sudo lttng add-context --kernel --type ppid
sudo lttng add-context --kernel --type callstack-kernel
sudo lttng add-context --kernel --type callstack-user

# enable all syscall events
# NOTE: this includes the LTTng internal syscalls as well
# so make sure to run the stop_lttng.sh script to filter them out.
sudo lttng enable-event --kernel --all --syscall

# ensure all PIDs are traced
sudo lttng track --kernel --pid --all

# start the tracing session
sudo lttng start syscalls-session-"${SESSION}"
echo "LTTng tracing session 'syscalls-session-${SESSION}' started."
