# 🚀 Creating a Portable Ubuntu Installation on an External Drive 🚀

In this tutorial, we'll guide you through creating a portable Ubuntu installation on an external drive, allowing you to use Ubuntu on different computers. Let's get started:

## 📋 Prerequisites

Before we begin, make sure you have the following:

- A bootable USB drive with Ubuntu 22.04.
- Rufus for Windows or mkusb for Linux.
- An external drive (back up data first).
- Some free time.

## 🚀 Getting Started

1. Boot into 'Try Ubuntu.'
2. Plug in your external drive.
3. Use GParted to unmount and delete all partitions on the external drive.

## 💼 Preparing the Portable Drive

1. Create a 100MB FAT32 partition for the GRUB bootloader.
   - Enable 'boot' and 'esp' flags for this partition.
2. Create an 8GB Linux-swap partition.
3. Create the main ext4 root partition of your desired size.

## 🌟 Installing Ubuntu 22.04

1. Choose your language and optionally install drivers.
2. Select 'Something else' for the installation type.
3. Assign partitions: EFI partition, swap, and root.
4. Set the external drive as the bootloader installation location.

## 🧩 Installing GRUB onto the ESP Partition

As mentioned earlier, the Ubuntu 19.10 installation process may create a dual-boot configuration, tying your external drive to the host computer. To address this, follow these two key steps:

1. **Preparing the External Drive:**

   - Boot into the Ubuntu installation thumb drive in "Try Ubuntu" mode.
   - Unmount the thumb drive media by running:
     ```shell
     sudo umount /media/ubuntu/<the uuid of your media>
     ```
   - Mount your external Ubuntu installation root volume:
     ```shell
     sudo mount /dev/sdb3 /mnt
     ```
   - Edit the `/etc/fstab` file to update UUIDs:
     ```shell
     sudo nano /mnt/etc/fstab
     ```
     - Comment out the line with the `/boot/efi` mount point.
     - Replace the current UUID with the one noted earlier.
     - Ensure the swap and root mount points reference the external drive.
     - Save and close the file.

2. **Installing GRUB with Removable Option:**
   - Mount the EFI/ESP system partition (usually /dev/sdb1):
     ```shell
     sudo mount /dev/sdb1 /mnt/boot/efi
     ```
   - Create necessary system process mount points:
     ```shell
     sudo mount -B /dev /mnt/dev
     sudo mount -B /dev/pts /mnt/dev/pts
     sudo mount -B /proc /mnt/proc
     sudo mount -B /sys /mnt/sys
     ```
   - Copy over current DNS settings for network access (optional):
     ```shell
     sudo cp /etc/resolv.conf /mnt/etc/
     ```
   - Load the efivars kernel module:
     ```shell
     modprobe efivars
     ```
   - Enter the chroot environment:
     ```shell
     sudo chroot /mnt
     ```
   - Install GRUB using the `--removable` option (replace /dev/sdb with your external drive's identifier):
     ```shell
     grub-install -d /usr/lib/grub/x86_64-efi --efi-directory=/boot/efi/ --removable /dev/sdb
     ```
   - Your external drive should now be bootable on any machine.

## 🔄 Alternative Method: Addressing Permissions

To deal with potential permission challenges during installation, follow these streamlined steps:

1. After installation, disregard the restart prompt; close it using the 'X' at the top-right.

2. Copy 'boot' and 'EFI' folders from the Ubuntu ISO to the 'boot' (ESP) partition (sdx3).

3. If permission problems arise, run Nautilus with elevated privileges:
   ```shell
   sudo -H nautilus
   ```

4. Copy the folders to the correct locations.

5. Use the 'Terminal':
   ```shell
   sudo mount /dev/sdx3 /mnt
   sudo -H nautilus
   ```

6. This opens a window to place directories properly.

7. Overwrite `grub.cfg` by copying it from sdx4 to sdx3:
   ```shell
   sudo cp /mnt/boot/grub/grub.cfg /boot/grub/
   ```

8. Reinstall GRUB with:
   ```shell
   sudo grub-install --boot-directory=/mnt/boot /dev/sdx
   ```

9. Power down, attach the HDD.

10. Shut down Ubuntu correctly using the top-right icon.

11. Lastly, connect the HDD and attempt to boot from it on a PC.

## 🧹 Cleaning Up the Dual Boot Configuration

To resolve a dual-boot configuration issue after creating your portable Ubuntu drive, follow these streamlined steps:

1. Run `cmd.exe` as an administrator.

2. Launch `diskpart`.

3. List and select your main disk (usually Disk 0):

   ```shell
   list disk
   select disk X
   ```

4. Identify the EFI partition (usually in FAT format):

   ```shell
   list vol
   ```

5. Select the EFI volume (typically named SYSTEM) and assign a free drive letter (e.g., Z):

   ```shell
   select vol Y
   assign letter=Z
   ```

6. Exit DiskPart and access the EFI partition:

   ```shell
   exit
   Z:
   ```

7. Navigate to the 'EFI' directory:

   ```shell
   cd EFI
   ```

8. Delete the 'ubuntu' boot directory:
   ```shell
   dir
   rmdir /S ubuntu
   ```
9. Reboot, and Windows will start without dual boot prompts.

## ℹ️ Resources

- [Full Tutorial](https://www.58bits.com/blog/2020/02/28/how-create-truly-portable-ubuntu-installation-external-usb-hdd-or-ssd)
- [Ask Ubuntu Discussion](https://askubuntu.com/questions/1332371/creating-a-pc-boot-able-ubuntu-installation/1332619#1332619)
- [Uninstall Grub](https://askubuntu.com/questions/429610/uninstall-grub-and-use-windows-bootloader)

For a detailed step-by-step guide, visit the [full tutorial](https://www.58bits.com/blog/2020/02/28/how-create-truly-portable-ubuntu-installation-external-usb-hdd-or-ssd) and the provided resources. Happy portable Ubuntu computing! 🌐🐧
