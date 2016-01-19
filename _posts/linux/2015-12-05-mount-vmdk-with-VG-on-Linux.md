---
layout: post
title:  "Access lvm2 partition on vmware virtual disk"
date:   2015-12-05 09:23:03 
categories: Linux
excerpt: vmdk vApp ovf ova Linux
---

* content
{:toc}

##Mount vApp on Linux

###Reference

>[Access lvm2 partition on vmware virtual disk](https://xliska.wordpress.com/2010/09/29/access-lvm2-partition-on-vmware-virtual-disk/) is where I found a good article about how to perform this.


>This is a guide for [vmware-mount](http://www.callum-macdonald.com/tag/vmware-mount-pl/) for vmware-mount

an blog


offical blog

vmware workstaion 12 pro trial:

###Example:

    [root@redhat6U6 tmp]# vmware-mount -f PowerPath.x86_64-2.0.1.0.206-disk1.vmdk /mnt
    [root@redhat6U6 mnt]# fdisk -lu flat 
    You must set cylinders.
    You can do this from the extra functions menu.
    
    Disk flat: 0 MB, 0 bytes
    4 heads, 32 sectors/track, 0 cylinders, total 0 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0xe5601e23
    
    Device Boot      Start         End      Blocks   Id  System
     flat1   *        2048      348163      173058   83  Linux
    Partition 1 has different physical/logical endings:
         phys=(1023, 3, 32) logical=(2720, 0, 4)
     flat2          350208    41943039    20796416   8e  Linux LVM
    Partition 2 has different physical/logical beginnings (non-Linux?):
         phys=(1023, 3, 32) logical=(2736, 0, 1)
    Partition 2 has different physical/logical endings:
         phys=(1023, 3, 32) logical=(327679, 3, 32)
    
    
    [root@redhat6U6 mnt]# losetup -o 179306496 /dev/loop0 flat 
    
    
    
    [root@redhat6U6 mnt]# pvdisplay
      --- Physical volume ---
      PV Name               /dev/sdaw2
      VG Name               vg_redhat6u6
      PV Size               930.51 GiB / not usable 3.00 MiB
      Allocatable           yes (but full)
      PE Size               4.00 MiB
      Total PE              238210
      Free PE               0
      Allocated PE          238210
      PV UUID               0JCHTl-KgCT-PmdQ-lIrU-02E4-FLHu-LRi8QA
       
      --- Physical volume ---
      PV Name               /dev/loop0
      VG Name               systemVG
      PV Size               19.83 GiB / not usable 0   
      Allocatable           yes (but full)
      PE Size               4.00 MiB
      Total PE              5077
      Free PE               0
      Allocated PE          5077
      PV UUID               g3Xar4-NubI-EUxH-Kr2R-cl32-MfmC-IfqnmX
    
    [root@redhat6U6 mnt]# lvscan
      ACTIVE            '/dev/vg_redhat6u6/lv_root' [922.68 GiB] inherit
      ACTIVE            '/dev/vg_redhat6u6/lv_swap' [7.83 GiB] inherit
      inactive          '/dev/systemVG/LVswap' [6.00 GiB] inherit
      inactive          '/dev/systemVG/LVRoot' [13.83 GiB] inherit
    [root@redhat6U6 mnt]# lvchang -ay /dev/systemVG/LVRoot 
    -bash: lvchang: command not found
    [root@redhat6U6 mnt]# lvchange -ay /dev/systemVG/LVRoot 
    
    
    
    [root@redhat6U6 /]# mount /dev/systemVG/LVRoot /ppve
    [root@redhat6U6 /]# cd /ppve
    [root@redhat6U6 ppve]# df -h
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/mapper/vg_redhat6u6-lv_root
                          909G   19G  844G   3% /
    tmpfs                 7.8G  136K  7.8G   1% /dev/shm
    /dev/sdaw1            477M   34M  418M   8% /boot
    /dev/mapper/systemVG-LVRoot
                           14G  1.7G   12G  13% /ppve
    
    
    [root@redhat6U6 ppve]# ll
    total 116
    drwxr-xr-x  2 root root  4096 Oct 12 12:57 bin
    drwxr-xr-x  3 root root  4096 Oct 12 12:58 boot
    drwxr-xr-x  3 root root  4096 Oct 12 12:57 dev
    drwxr-xr-x 76 root root  4096 Oct 12 12:59 etc
    drwxr-xr-x  2 root root  4096 May  5  2010 home
    drwxr-xr-x  2 root root  4096 Oct 12 12:58 image
    drwxr-xr-x 10 root root  4096 Oct 12 12:57 lib
    drwxr-xr-x  8 root root 12288 Oct 12 12:58 lib64
    drwx------  2 root root 16384 Oct 12 13:00 lost+found
    drwxr-xr-x  2 root root  4096 May  5  2010 media
    drwxr-xr-x  2 root root  4096 May  5  2010 mnt
    drwxr-xr-x  6 root root  4096 Oct 12 12:58 opt
    drwxr-xr-x  2 root root  4096 Oct 12 12:57 proc
    drwx------  4 root root  4096 Oct 12 12:57 root
    drwxr-xr-x  3 root root 12288 Oct 12 12:58 sbin
    drwxr-xr-x  2 root root  4096 May  5  2010 selinux
    drwxr-xr-x  4 root root  4096 Oct 12 12:57 srv
    drwxr-xr-x  2 root root  4096 Oct 12 13:00 swap
    drwxr-xr-x  2 root root  4096 May  5  2010 sys
    drwxrwxrwt  6 root root  4096 Oct 12 12:59 tmp
    drwxr-xr-x 13 root root  4096 Oct 12 12:57 usr
    drwxr-xr-x 14 root root  4096 Oct 12 12:57 var




