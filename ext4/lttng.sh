#!/bin/bash

# check for lttng installation and version
cexists() {
	command -v "$1" >/dev/null 2>&1
}

if cexists "lttng"; then
	echo 'lttng found!'
else
	echo 'please install lttng!!'
	exit 1
fi

# create a session
sudo lttng create ext4-session -o /tmp/lttng-traces-2

# EXT4 functions – match every eBPF kprobe symbol exactly
sudo lttng enable-event --kernel --probe=ext4_file_write_iter ext4_file_write_iter
sudo lttng enable-event --kernel --probe=ext4_fallocate ext4_fallocate
sudo lttng enable-event --kernel --probe=ext4_sync_file ext4_sync_file
sudo lttng enable-event --kernel --probe=ext4_create ext4_create
sudo lttng enable-event --kernel --probe=ext4_unlink ext4_unlink
sudo lttng enable-event --kernel --probe=ext4_fill_super ext4_fill_super
sudo lttng enable-event --kernel --probe=ext4_delete_entry ext4_delete_entry
sudo lttng enable-event --kernel --probe=ext4_ext_map_blocks ext4_ext_map_blocks
sudo lttng enable-event --kernel --probe=ext4_ext_handle_unwritten_extents ext4_ext_handle_unwritten_extents
sudo lttng enable-event --kernel --probe=ext4_mb_new_group_pa ext4_mb_new_group_pa
sudo lttng enable-event --kernel --probe=ext4_group_add ext4_group_add
sudo lttng enable-event --kernel --probe=ext4_set_inode_flags ext4_set_inode_flags
sudo lttng enable-event --kernel --probe=ext4_init_inode_table ext4_init_inode_table
sudo lttng enable-event --kernel --probe=ext4_multi_mount_protect ext4_multi_mount_protect
sudo lttng enable-event --kernel --probe=ext4_quota_write ext4_quota_write
sudo lttng enable-event --kernel --probe=ext4_quota_read ext4_quota_read
sudo lttng enable-event --kernel --probe=ext4_read_inline_data ext4_read_inline_data
sudo lttng enable-event --kernel --probe=ext4_write_inline_data ext4_write_inline_data
sudo lttng enable-event --kernel --probe=ext4_block_bitmap_csum_verify ext4_block_bitmap_csum_verify
sudo lttng enable-event --kernel --probe=ext4_xattr_inode_get ext4_xattr_inode_get
sudo lttng enable-event --kernel --probe=ext4_dx_find_entry ext4_dx_find_entry
sudo lttng enable-event --kernel --probe=ext4_dx_add_entry ext4_dx_add_entry
sudo lttng enable-event --kernel --probe=ext4_add_entry ext4_add_entry
sudo lttng enable-event --kernel --probe=ext4_xattr_get ext4_xattr_get
sudo lttng enable-event --kernel --probe=ext4_xattr_set ext4_xattr_set
sudo lttng enable-event --kernel --probe=ext4_resize_fs ext4_resize_fs

# JBD2 – journaling hooks
sudo lttng enable-event --kernel --probe=jbd2_journal_start jbd2_journal_start
sudo lttng enable-event --kernel --probe=jbd2_journal_commit_transaction jbd2_journal_commit_transaction

# FSVerity – only if symbol exists on your kernel
sudo lttng enable-event --kernel --probe=fsverity_verify_signature fsverity_verify_signature

echo 'session built.'
echo 'run "sudo lttng start --session=ext4-session"'
echo 'execute your workload ...'
echo 'run "sudo lttng stop --session=ext4-session"'
echo 'run "sudo lttng destroy --session=ext4-session"'
echo 'output at "/tmp/lttng-traces-2"'
echo 'use babeltrace2 to read the results.'
echo 'happy life!'
