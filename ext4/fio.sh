#!/bin/bash

# FIO Workloads for EXT4 Feature Testing
echo "=== FIO EXT4 Feature Testing Suite ==="
echo "This script runs various FIO workloads to exercise specific EXT4 features"
echo ""


# Create test directory
TEST_DIR="fio_ext4_test"
mkdir -p $TEST_DIR
cd $TEST_DIR

echo "Test directory: $(pwd)"
echo ""

# Function to run FIO and show what EXT4 features it should trigger
run_fio_test() {
    local name="$1"
    local config="$2"
    local features="$3"
    
    echo "=== TEST: $name ==="
    echo "Expected EXT4 features: $features"
    echo "FIO Config:"
    echo "$config"
    echo ""
    echo "$config" > ${name}.fio
    echo "Running: fio ${name}.fio"
    fio ${name}.fio
    echo "Completed: $name"
    echo "----------------------------------------"
    echo ""
}

echo "1. SEQUENTIAL WRITE TEST (Basic extent allocation)"
run_fio_test "seq_write" "[seq_write]
rw=write
size=100M
bs=4k
direct=1
filename=seq_test_file
name=sequential_write" "write, extent, bigalloc, has_journal"

echo "2. RANDOM WRITE TEST (Extent fragmentation)"
run_fio_test "rand_write" "[rand_write]
rw=randwrite
size=100M
bs=4k
direct=1
filename=rand_test_file
name=random_write" "write, extent, bigalloc, has_journal"

echo "3. FSYNC HEAVY TEST (Journal operations)"
run_fio_test "fsync_heavy" "[fsync_heavy]
rw=write
size=50M
bs=4k
direct=0
fsync=1
filename=fsync_test_file
name=fsync_heavy" "write, fsync, has_journal, extent"

echo "4. FALLOCATE TEST (Pre-allocation)"
run_fio_test "fallocate_test" "[fallocate_test]
rw=write
size=200M
bs=64k
fallocate=native
filename=falloc_test_file
name=fallocate_test" "fallocate, extent, huge_file, bigalloc"

echo "5. LARGE FILE TEST (Huge file support)"
run_fio_test "large_file" "[large_file]
rw=write
size=1G
bs=1M
direct=1
filename=large_test_file
name=large_file" "write, extent, huge_file, large_file, bigalloc"

echo "6. MIXED I/O TEST (Various patterns)"
run_fio_test "mixed_io" "[mixed_io]
rw=randrw
rwmixread=70
size=100M
bs=4k
direct=1
filename=mixed_test_file
name=mixed_io" "write, extent, bigalloc, has_journal"

echo "7. SMALL FILES TEST (Directory operations, filetype)"
run_fio_test "small_files" "[small_files]
rw=write
size=1M
bs=4k
nrfiles=100
filesize=10k
filename_format=small_file.\$jobnum.\$filenum
name=small_files" "create, write, filetype, dir_nlink, ext_attr"

echo "8. SYNC INTENSIVE TEST (Heavy journal activity)"
run_fio_test "sync_intensive" "[sync_intensive]
rw=write
size=50M
bs=4k
direct=0
sync=1
filename=sync_test_file
name=sync_intensive" "write, fsync, has_journal, extent"

echo "9. TRUNCATE/EXTEND TEST (File size operations)"
run_fio_test "truncate_test" "[truncate_test]
rw=write
size=100M
bs=4k
file_append=1
filename=truncate_test_file
name=truncate_test" "write, extent, large_file, has_journal"

echo "10. ZERO WRITE TEST (Unwritten extents)"
run_fio_test "zero_write" "[zero_write]
rw=write
size=100M
bs=64k
zero_buffers=1
filename=zero_test_file
name=zero_write" "write, extent, bigalloc, has_journal"

echo ""
echo "=== FIO Test Suite Completed ==="
echo "Files created in: $(pwd)"
echo "To clean up: cd .. && rm -rf $TEST_DIR"
echo ""
echo "File sizes:"
ls -lh *.file 2>/dev/null || echo "No .file extensions found"
ls -lh *test_file* 2>/dev/null || echo "No test files found"
