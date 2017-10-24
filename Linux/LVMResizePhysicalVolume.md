# HowTo Resize LVM Physical Volume on RHEL7.4

In this how to we will see how to resize LVM physical when the underlinyng VirtualDisk was grow up resizing.

+ Run `fdisk` over the partition that was resised.
++ In this example, the disk was /dev/sda. Once fdisk display, it remains asking an option.
++ We must tip `p` and then hit `enter` to print the partition table.

```
[root@gcpamysql01 ~]# fdisk /dev/sda

The device presents a logical sector size that is smaller than
the physical sector size. Aligning to a physical sector (or optimal
I/O) size boundary is recommended, or performance may be impacted.
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Disk identifier: 0x0001fe22

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      526335      262144   83  Linux
/dev/sda2          526336    21514239    10493952   8e  Linux LVM

Command (m for help): d
Partition number (1,2, default 2): 2
Partition 2 is deleted

Command (m for help): p

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Disk identifier: 0x0001fe22

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      526335      262144   83  Linux

Command (m for help): n
Partition type:
   p   primary (1 primary, 0 extended, 3 free)
   e   extended
Select (default p): p
Partition number (2-4, default 2): 2
First sector (526336-41943039, default 526336): 
Using default value 526336
Last sector, +sectors or +size{K,M,G} (526336-41943039, default 41943039): 
Using default value 41943039
Partition 2 of type Linux and of size 19.8 GiB is set

Command (m for help): p

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Disk identifier: 0x0001fe22

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      526335      262144   83  Linux
/dev/sda2          526336    41943039    20708352   83  Linux

Command (m for help): t
Partition number (1,2, default 2): 2
Hex code (type L to list all codes): L 

 0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris        
 1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 hidden C:  c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extended  c7  Syrinx         
 5  Extended        41  PPC PReP Boot   86  NTFS volume set da  Non-FS data    
 6  FAT16           42  SFS             87  NTFS volume set db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Dell Utility   
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt         
 9  AIX bootable    4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access     
 a  OS/2 Boot Manag 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad hi eb  BeOS fs        
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         ee  GPT            
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ef  EFI (FAT-12/16/
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        f0  Linux/PA-RISC b
11  Hidden FAT12    56  Golden Bow      a8  Darwin UFS      f1  SpeedStor      
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f4  SpeedStor      
14  Hidden FAT16 <3 61  SpeedStor       ab  Darwin boot     f2  DOS secondary  
16  Hidden FAT16    63  GNU HURD or Sys af  HFS / HFS+      fb  VMware VMFS    
17  Hidden HPFS/NTF 64  Novell Netware  b7  BSDI fs         fc  VMware VMKCORE 
18  AST SmartSleep  65  Novell Netware  b8  BSDI swap       fd  Linux raid auto
1b  Hidden W95 FAT3 70  DiskSecure Mult bb  Boot Wizard hid fe  LANstep        
1c  Hidden W95 FAT3 75  PC/IX           be  Solaris boot    ff  BBT            
1e  Hidden W95 FAT1 80  Old Minix      
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): p

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Disk identifier: 0x0001fe22

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      526335      262144   83  Linux
/dev/sda2          526336    41943039    20708352   8e  Linux LVM

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.
[root@gcpamysql01 ~]# ls /sys/class/scsi_disk/
2:0:0:0
[root@gcpamysql01 ~]# echo '1' > /sys/class/scsi_d
scsi_device/ scsi_disk/   
[root@gcpamysql01 ~]# echo '1' > /sys/class/scsi_d
scsi_device/ scsi_disk/   
[root@gcpamysql01 ~]# echo '1' > /sys/class/scsi_disk/2\:0\:0\:0/device/re
rescan  rev     
[root@gcpamysql01 ~]# echo '1' > /sys/class/scsi_disk/2\:0\:0\:0/device/re
rescan  rev     
[root@gcpamysql01 ~]# echo '1' > /sys/class/scsi_disk/2\:0\:0\:0/device/rescan 
[root@gcpamysql01 ~]# fdisk -l

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Disk identifier: 0x0001fe22

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      526335      262144   83  Linux
/dev/sda2          526336    41943039    20708352   8e  Linux LVM

Disk /dev/mapper/rhel-root: 5368 MB, 5368709120 bytes, 10485760 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rhel-swap: 1073 MB, 1073741824 bytes, 2097152 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rhel-home: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rhel-var: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes

[root@gcpamysql01 ~]# 
[root@gcpamysql01 ~]# 
[root@gcpamysql01 ~]# fdisk /dev/sda

The device presents a logical sector size that is smaller than
the physical sector size. Aligning to a physical sector (or optimal
I/O) size boundary is recommended, or performance may be impacted.
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Disk identifier: 0x0001fe22

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      526335      262144   83  Linux
/dev/sda2          526336    41943039    20708352   8e  Linux LVM

Command (m for help): q

[root@gcpamysql01 ~]# 
[root@gcpamysql01 ~]# 
[root@gcpamysql01 ~]# shutdown -r now
Connection to 10.1.120.5 closed by remote host.
Connection to 10.1.120.5 closed.
cepxio@devuan:~$ ssh root@10.1.120.5
root@10.1.120.5's password: 
Permission denied, please try again.
root@10.1.120.5's password: 
Permission denied, please try again.
root@10.1.120.5's password: 
Last failed login: Mon Oct 23 17:19:36 ART 2017 from 10.1.123.60 on ssh:notty
There were 2 failed login attempts since the last successful login.
Last login: Mon Oct 23 15:18:52 2017 from 10.1.123.60
[root@localhost ~]# 
[root@localhost ~]# 
[root@localhost ~]# fdisk -l

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: dos
Disk identifier: 0x0001fe22

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      526335      262144   83  Linux
/dev/sda2          526336    41943039    20708352   8e  Linux LVM

Disk /dev/mapper/rhel-root: 5368 MB, 5368709120 bytes, 10485760 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rhel-swap: 1073 MB, 1073741824 bytes, 2097152 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rhel-home: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rhel-var: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes

[root@localhost ~]# pvs
  PV         VG   Fmt  Attr PSize  PFree
  /dev/sda2  rhel lvm2 a--  10.00g 4.00m
[root@localhost ~]# pvdisplay 
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rhel
  PV Size               10.01 GiB / not usable 4.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              2561
  Free PE               1
  Allocated PE          2560
  PV UUID               PvE1Rg-Oqdh-x28q-JGP8-tn81-6nBT-Wdk2Op
   
[root@localhost ~]# pvresize /dev/sda2 
  Physical volume "/dev/sda2" changed
  1 physical volume(s) resized / 0 physical volume(s) not resized
[root@localhost ~]# 
[root@localhost ~]# 
[root@localhost ~]# pvs
  PV         VG   Fmt  Attr PSize  PFree
  /dev/sda2  rhel lvm2 a--  19.75g 9.75g
[root@localhost ~]# 

Note: The volumen group is auto resized because the underline physical disk 
