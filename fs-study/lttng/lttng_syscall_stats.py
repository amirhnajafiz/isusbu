#!/usr/bin/env python3
import csv
import re
import sys
from collections import Counter, defaultdict

# Usage: python3 lttng_syscall_stats.py trace.txt
# Analyzes syscall traces from LTTng trace files.
# Produces a summary of syscall counts and argument statistics.
# NOTE: don't modify the traceing results of LTTng, otherwise the parsing may fail.



def count_syscalls(trace_file: str) -> tuple[Counter, defaultdict, defaultdict]:
    """Parse the trace file and count syscalls and their arguments."""
    # regex to match syscall events
    line_re = re.compile(
        r"syscall_(entry|exit)_([a-zA-Z0-9_]+):.*?\{(.*)\}"
    )

    # data structures
    syscall_counts = Counter()
    syscall_type_counts = defaultdict(lambda: Counter())
    arg_values = defaultdict(lambda: defaultdict(Counter))

    with open(trace_file) as f:
        for line in f:
            m = line_re.search(line)
            if not m:
                continue

            call_type, syscall_name, args_str = m.groups()
            syscall_counts[syscall_name] += 1
            syscall_type_counts[syscall_name][call_type] += 1

            # parse args key=value pairs inside { ... }
            args = {}
            for kv in re.finditer(r"(\w+)\s*=\s*([^,}]+)", args_str):
                key, value = kv.groups()
                args[key.strip()] = value.strip()

            # collect argument stats for known flag-like args
            for k, v in args.items():
                if any(x in k for x in ("flag", "op", "mode")):
                    arg_values[syscall_name][k][v] += 1

    return syscall_counts, syscall_type_counts, arg_values

def export_summary_as_csv(syscall_counts: Counter, syscall_type_counts: defaultdict, arg_values: defaultdict, output_files: list[str]):
    """Export the summary of syscall counts and argument statistics to a CSV file."""
    with open(output_files[0], 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)

        # Write syscall counts
        writer.writerow(["Syscall Name", "Total Count", "Entry Count", "Exit Count"])
        for name, count in syscall_counts.most_common():
            entry = syscall_type_counts[name]["entry"]
            exit_ = syscall_type_counts[name]["exit"]
            writer.writerow([name, count, entry, exit_])

    with open(output_files[1], 'a', newline='') as csvfile:
        writer = csv.writer(csvfile)
        # Write argument value stats
        writer.writerow([])
        writer.writerow(["Syscall Name", "Argument", "Value", "Count"])
        for syscall, argdict in arg_values.items():
            for arg, vals in argdict.items():
                for val, c in vals.most_common():
                    writer.writerow([syscall, arg, val, c])

def print_summary(syscall_counts: Counter, syscall_type_counts: defaultdict, arg_values: defaultdict):
    """Print a summary of syscall counts and argument statistics."""
    print("\n=== Syscall Counts ===")
    for name, count in syscall_counts.most_common():
        entry = syscall_type_counts[name]["entry"]
        exit_ = syscall_type_counts[name]["exit"]
        print(f"{name:25s} total={count:6d}  entry={entry:6d}  exit={exit_:6d}")

    print("\n=== Argument Value Stats (flags, ops, modes) ===")
    for syscall, argdict in arg_values.items():
        print(f"\n{syscall}:")
        for arg, vals in argdict.items():
            print(f"  {arg}:")
            for val, c in vals.most_common():
                print(f"    {val:15s} -> {c}")

if __name__ == "__main__":
    # check args
    if len(sys.argv) < 2:
        print("Usage: python3 lttng_syscall_stats.py <trace_file>")
        sys.exit(1)
    
    print("Analyzing syscall traces...")

    # assign the trace file path from the 1st command line argument
    trace_file = sys.argv[1]

    # parse and count syscalls
    syscall_counts, syscall_type_counts, arg_values = count_syscalls(trace_file)

    # export summary as CSV
    output_files = [trace_file + "_syscall_summary.csv", trace_file + "_syscall_args_summary.csv"]
    export_summary_as_csv(syscall_counts, syscall_type_counts, arg_values, output_files)
    
    # print the summary
    print_summary(syscall_counts, syscall_type_counts, arg_values)

    print("\nDone.")
