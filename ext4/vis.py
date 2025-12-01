import re
import matplotlib.pyplot as plt
from collections import Counter

# Read ext4 functions from tracepoints.txt
with open('ext4/tracepoints.txt') as f:
    ext4_funcs = set(line.strip() for line in f if line.strip())

# Parse logs and build hit maps
event_hits = Counter()
address_hits = Counter()

with open('ext4-session-1') as f:
    for line in f:
        # Find ext4 function event
        m = re.match(r'.*?\s+(ext4_\w+):', line)
        if m:
            func = m.group(1)
            if func in ext4_funcs:
                event_hits[func] += 1
                # Find all callstack addresses
                callstack = re.findall(r'0x[0-9A-Fa-f]+', line)
                for addr in callstack:
                    address_hits[addr] += 1

# Plot top N function events
top_funcs = event_hits.most_common(100)
func_names = [item[0] for item in top_funcs]
func_counts = [item[1] for item in top_funcs]

plt.figure(figsize=(10,5))
plt.barh(func_names, func_counts)
plt.gca().invert_yaxis()
plt.title('ext4 Function Event Hit Map')
plt.xlabel('Hit Count')
plt.tight_layout()
plt.show()

# Plot top N addresses in callstack
top_addrs = address_hits.most_common(100)
addr_names = [item[0] for item in top_addrs]
addr_counts = [item[1] for item in top_addrs]

plt.figure(figsize=(10,5))
plt.barh(addr_names, addr_counts)
plt.gca().invert_yaxis()
plt.title('Call Stack Kernel Address Hit Map')
plt.xlabel('Hit Count')
plt.tight_layout()
plt.show()
