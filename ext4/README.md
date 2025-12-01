# Ext4

```bash
# make a 2GB empty image file
dd if=/dev/zero of=ext4_test.img bs=1M count=2048

# format it as Ext4
mkfs.ext4 ext4_test.img

# make a mount point
mkdir /mnt/ext4test

# mount it using a loop device
sudo mount -o loop ext4_test.img /mnt/ext4test
```

```bash
cd ~
sudo umount /mnt/ext4test
rm -rf /mnt/ext4test

rm ext4_test.img
```
