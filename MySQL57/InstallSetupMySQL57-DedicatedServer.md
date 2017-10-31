# Phase 2

## Install, Setup and Secure MySQL 5.7 

+ Create LVMs if not did it on RHEL installation (the /var must be a separated partition when intalled RHEL) 
  + /var/lib/mysql 
  + /var/lib/mysql-binlog
  + /var/lib/mysql-relay
  + /var/lib/mysql-redolog

### Resize physical partition 

If you created the server with a small LVM Physical Volume, you can use the steps in te following link

[Howto Resize LVM](https://github.com/Cepxio/MySQL/blob/master/Linux/LVMResizePhysicalVolume.md)

### Create de logical volume for MySQL.

The server in this lab already have only the `/var` partition.

We will add three partitions more to it.

#### First partition, the mysql database directory.

With lvcreate we'll create new LVMs. 

The command means `lvcreate [create command] -L 3G [size] -n mysql [new LVM name] rhel [destined volume group]`

E.g

  ```
  [root@localhost mysql]# lvcreate -L 3G -n mysql rhel
    Logical volume "mysql" created.
  [root@localhost mysql]# lvs
    LV    VG   Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
    home  rhel -wi-ao---- 2.00g                                                    
    mysql rhel -wi-a----- 3.00g                                                    
    root  rhel -wi-ao---- 5.00g                                                    
    swap  rhel -wi-ao---- 1.00g                                                    
    var   rhel -wi-ao---- 2.00g                                                    
  [root@localhost mysql]# 
  ```

Then, we need to give a format to the new volume, in this case will be XFS.

  ```
  [root@localhost mysql]# mkfs.xfs /dev/rhel/mysql 
  meta-data=/dev/rhel/mysql        isize=512    agcount=4, agsize=196608 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=1        finobt=0, sparse=0
  data     =                       bsize=4096   blocks=786432, imaxpct=25
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
  log      =internal log           bsize=4096   blocks=2560, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  ```

#### Second partition, the binlog directory

As the previous step, the same action, create LVM and format it.
For this example the size is smaller than datadir.

  ```
  [root@localhost mysql]# lvcreate -L 1G -n binlog rhel
    Logical volume "binlog" created.
  [root@localhost mysql]# mkfs.xfs /dev/rhel/binlog 
  meta-data=/dev/rhel/binlog       isize=512    agcount=4, agsize=65536 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=1        finobt=0, sparse=0
  data     =                       bsize=4096   blocks=262144, imaxpct=25
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
  log      =internal log           bsize=4096   blocks=2560, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  ```

#### Third partition, the relay binlog directory

Same action, create LVM and format it.
For this example the size is smaller than datadir, too.

  ```
  [root@localhost mysql]# lvcreate -L 1G -n relay-bin rhel
    Logical volume "relay-bin" created.
  [root@localhost mysql]# mkfs.xfs /dev/rhel/relay-bin 
  meta-data=/dev/rhel/relay-bin    isize=512    agcount=4, agsize=65536 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=1        finobt=0, sparse=0
  data     =                       bsize=4096   blocks=262144, imaxpct=25
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
  log      =internal log           bsize=4096   blocks=2560, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  [root@localhost mysql]# 
  ```
### Forth partition, the redolog directory 

Same action, create LVM and format it
The size of the LVM must be upper than the size we calculate for the redo log (WAL)

  ```
  [root@localhost mysql]# lvcreate -L 1.5G -n redolog rhel
    Logical volume "redolog" created.
  [root@localhost mysql]# mkfs.xfs /dev/rhel/redolog 
  meta-data=/dev/rhel/redolog      isize=512    agcount=4, agsize=98304 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=1        finobt=0, sparse=0
  data     =                       bsize=4096   blocks=393216, imaxpct=25
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
  log      =internal log           bsize=4096   blocks=2560, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  [root@localhost mysql]# 
  ```

Finally we can see all the lvm 

  ```
  [root@localhost mysql]# lvs
    LV        VG   Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
    binlog    rhel -wi-ao---- 1.00g                                                    
    home      rhel -wi-ao---- 2.00g                                                    
    mysql     rhel -wi-ao---- 3.00g                                                    
    redolog   rhel -wi-a----- 1.50g                                                    
    relay-bin rhel -wi-ao---- 1.00g                                                    
    root      rhel -wi-ao---- 5.00g                                                    
    swap      rhel -wi-ao---- 1.00g                                                    
    var       rhel -wi-ao---- 2.00g                             
  ```

#### Now, is time to reorganize the datadir to adapt the new disk (LVM partitions)

+ Create a new datadir directory with name mysql.

  `[root@localhost lib]# mkdir mysql`

+ Change owner to de new directory

  `[root@localhost lib]# chown -R mysql: mysql`

+ Create the new binlog directory and change the owner to mysql

  `[root@localhost lib]# mkdir mysql-binlog
  [root@localhost lib]# chown -R mysql: mysql-binlog`

+ Create the new relay binlog directory and change the owner to mysql

  `[root@localhost lib]# mkdir mysql-relay
  [root@localhost lib]# chown -R mysql: mysql-relay`

+ Create the new redo log directory and change the owner to mysql

  `[root@localhost lib]# mkdir mysql-redolog
  [root@localhost lib]# chown -R mysql: mysql-redolog`


+ Edit de fstab to mount new dirs

  ```
  [root@localhost lib]# cat /etc/fstab 

  #
  # /etc/fstab
  # Created by anaconda on Thu Oct  5 17:05:31 2017
  #
  # Accessible filesystems, by reference, are maintained under '/dev/disk'
  # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
  #
  /dev/mapper/rhel-root   	/                       xfs     defaults        0 0
  UUID=fe8bbeab-84e4-4bab-8baf-7a604eea8b5b /boot                   xfs     defaults        0 0
  /dev/mapper/rhel-home   	/home                   xfs     defaults        0 0
  /dev/mapper/rhel-var    	/var                    xfs     defaults        0 0
  /dev/mapper/rhel-swap   	swap                    swap    defaults        0 0
  /dev/mapper/rhel-mysql		/var/lib/mysql          xfs     relatime,rw,exec,async,auto,dev,user        0 0
  /dev/mapper/rhel-binlog		/var/lib/mysql-binlog   xfs     relatime,rw,exec,async,auto,dev,user        0 0
  /dev/mapper/rhel-relay--bin	/var/lib/mysql-relay    xfs     relatime,rw,exec,async,auto,dev,user        0 0
  /dev/mapper/rhel-redolog	/var/lib/mysql-redolog  xfs     relatime,rw,exec,async,auto,dev,user        0 0
  [root@localhost ~]# 
  ```

+ Mount the new LVMs in the new dirs and check

  ```
  [root@localhost lib]# mount -a
  [root@localhost lib]# 
  [root@localhost lib]# mount
  sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
  proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
  devtmpfs on /dev type devtmpfs (rw,nosuid,size=894184k,nr_inodes=223546,mode=755)
  securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
  tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
  devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
  tmpfs on /run type tmpfs (rw,nosuid,nodev,mode=755)
  tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
  cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
  pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
  cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
  cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
  cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
  cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_prio,net_cls)
  cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
  cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
  cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
  cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
  cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
  cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
  configfs on /sys/kernel/config type configfs (rw,relatime)
  /dev/mapper/rhel-root on / type xfs (rw,relatime,attr2,inode64,noquota)
  systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=29,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
  hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
  debugfs on /sys/kernel/debug type debugfs (rw,relatime)
  mqueue on /dev/mqueue type mqueue (rw,relatime)
  /dev/sda1 on /boot type xfs (rw,relatime,attr2,inode64,noquota)
  /dev/mapper/rhel-var on /var type xfs (rw,relatime,attr2,inode64,noquota)
  /dev/mapper/rhel-home on /home type xfs (rw,relatime,attr2,inode64,noquota)
  /dev/mapper/rhel-relay--bin on /var/lib/mysql-relay type xfs (rw,nosuid,nodev,noexec,relatime,attr2,inode64,noquota,user)
  /dev/mapper/rhel-mysql on /var/lib/mysql type xfs (rw,relatime,attr2,inode64,noquota)
  /dev/mapper/rhel-binlog on /var/lib/mysql-binlog type xfs (rw,relatime,attr2,inode64,noquota)
  tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,size=180988k,mode=700)
  [root@localhost ~]# 
  ```

+ Check that all directories exists and are mounted.

  ```
  [root@localhost lib]# ls -lh | egrep mysql
  drwxr-xr-x  8 mysql   mysql   4.0K Oct 31 12:51 mysql
  drwxr-xr-x  2 mysql   mysql    245 Oct 31 12:44 mysql-binlog
  drwxr-x---. 2 mysql   mysql      6 Oct  6 22:16 mysql-files
  drwxr-x---. 2 mysql   mysql      6 Jun 22 11:41 mysql-keyring
  drwxr-xr-x  2 mysql   mysql     44 Oct 31 10:45 mysql-redolog
  drwxr-xr-x  2 mysql   mysql      6 Oct 23 17:43 mysql-relay
  
  ```

### MySQL Server installation

+ Proceed to install mysql repo

	`$ yum install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm`

+ Then install mysql community edition

	`[root@localhost lib]# yum install mysql-community-server.x86_64`

+ Before start the server, we must do some change to adapt de standar datadir installation to the LVM partitions created


  + Add correspond entries to my.cnf

  ```
  # For advice on how to change settings please see
  # http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html
  
  [client]
  
  port	= 3306
  socket	= /var/lib/mysql/mysql.sock
  
  [mysqld]
  
  port				= 3306
  datadir 			= /var/lib/mysql
  log-error 			= /var/log/mysqld.log
  pid-file 			= /var/run/mysqld/mysqld.pid
  socket 				= /var/lib/mysql/mysql.sock
  skip_name_resolve 		= ON
  explicit_defaults_for_timestamp = 1
  
  # Remove leading # to set options mainly useful for reporting servers.
  # The server defaults are faster for transactions and fast SELECTs.
  # Adjust sizes as needed, experiment to find the optimal values.
  # join_buffer_size = 128M
  # sort_buffer_size = 2M
  # read_rnd_buffer_size = 2M
  
  symbolic-links          = 0 	# Disabling symbolic-links is recommended to prevent assorted security risks
  slow_query_log 		= ON
  
  #
  ## GTID Replication Settings
  #
  gtid_mode 			= ON
  enforce-gtid-consistency 	= TRUE
  #gtid_executed_compression_period = 1000
  
  
  #
  # Master config
  #
  server-id 		= 1
  log_bin			= /var/lib/mysql-binlog/gcpamysql01-bin
  max_binlog_size		= 100M
  expire_logs_days 	= 7
  sync_binlog 		= 1
  skip-networking 	= OFF
  master_info_repository	= TABLE
  
  #
  # Slave config
  #
  skip_slave_start 	= ON
  relay_log		= /var/lib/mysql-relay/gcpamysql01-relay-bin
  max_relay_log_size 	= 100M
  relay_log_space_limit 	= 1G
  # slave-parallel-workers 	= 4
  # slave-parallel-type 	= LOGICAL_CLOCK
  # report_host		= 10.1.120.5
  # report_port		= 3306
  
  #
  ## INNODB
  #
  default_storage_engine		= InnoDB	# The default is implicit, but add for information purpose.
  innodb_file_per_table		= 1		# 
  
  				
  # * Buffer Pool [Innodb Buffer] *
  innodb_buffer_pool_size 	= 1236M		# The memory area that holds cached data for tables and indexes. 
  						# For efficiency of high-volume read operations, the buffer pool is
  						# divided into pages that can potentially hold multiple rows.
  						# The amount of RAM for the most important data cache in MySQL. 
  						# Start at 70% of total RAM for dedicated server, else 10%.
  
  innodb_buffer_pool_instances    = 1             # The total memory size specified by innodb_buffer_pool_size is 
  						# divided among all buffer pool instances.
  						# Having multiple buffer pool instances reduces contention for 
  						# exclusive access to data structures that manage the buffer pool.
  						# Default 8 or 1 if innodb_buffer_pool_size < 1GB
  						# Try to give 1G per instance.
  
  innodb_adaptive_flushing	= ON		# Flushing dirty pages in the buffer pool based on workload
  
  innodb_old_blocks_pct		= 25		# Min: 5 - Max: 95 - Actual: 25 (%27.7 of the pool)
  						# That mean the % of the pool that hold old pages.
  						# Reduce the value for large tables scan.
  						# Increase the value for small tables that fit into buffer pool.
  
  # * Log Buffer [RedoLog and LRU] *
  innodb_flush_log_at_trx_commit 	= 1		# Control how content is flushing to disk 
  						# 0: 1: 2: 
  
  #innodb_log_buffer_size		=
  #innodb_flush_log_at_timeout	= 
  
  # * DoubleWrite Buffer *
  innodb_doublewrite 		= ON		# Default = ON. 
  
  # * RedoLog [Log Files] *
  
  innodb_log_group_home_dir	= /var/lib/mysql-redolog/
  
  innodb_log_file_size		= 768M 		# Configuring InnoDB’s Redo space size is one of the most important 
  						# configuration options for write-intensive workloads. 
  						# It often makes sense to set the total size of the log files as 
  						# large as the buffer pool or even larger.
  						# Increasing the Redo space also means longer recovery times when 
  						# the system loses power or crashes for other reasons.
  innodb_log_files_in_group 	= 2
  
  
  [mysqldump]
  
  max_allowed_packet 	= 512M

  ```
  + In the cnf we configured some variables that control the directories for the LVM partition
    i.e
    innodb_log_group_home_dir 	> Control de redo log directory
    relay_log 			> Control de relay log directory
    log_bin			> Control de binlog directory

+ Now enable and start the server

	`[root@localhost lib]# systemctl enable mysqld`
	
	`[root@localhost lib]# systemctl start mysqld`
	
	`[root@localhost lib]# egrep pass /var/log/mysqld.log`
	
	`[root@localhost lib]# mysql -u root -p'4x7DL%y,dcUs'`

+ Change password

	`mysql>  ALTER USER root@localhost IDENTIFY BY 'Isolation Level54$' PASSWORD EXPIRE NEVER;`

+ Add Monitoring users if desired

  ```
  mysql> CREATE USER IF NOT EXISTS centreon@10.1.123.87 IDENTIFIED BY 'C3ntre0n$' PASSWORD EXPIRE NEVER;
  Query OK, 0 rows affected (0.00 sec)

  mysql> GRANT USAGE ON *.* TO 'centreon'@'10.1.123.87';
  Query OK, 0 rows affected (0.00 sec)

  6- Add user for replication

  mysql> CREATE USER 'slave_user'@'10.1.120.%' IDENTIFIED BY 'Cl4rin1' PASSWORD EXPIRE NEVER;

  mysql> GRANT REPLICATION SLAVE ON *.* TO 'slave_user'@'10.1.120.%'
  ```

+ Verify users

  `mysql> select user,host from mysql.user order by 1,2;`


+ Verify taht Setup GTID Replication on GCPAMYSQL01 - Master was done

  a. Enable gtid adding this entries to my.cnf

  ```
  gtid_mode = ON
  enforce-gtid-consistency = TRUE
  ```

  b. If not, Add Master conf into my.cnf

  ```
  log-bin = mysql01-bin
  server-id = 1
  sync_binlog = 1
  innodb_flush_log_at_trx_commit = 1
  ```

+ Repeat the same steps on slave. 
+ Setup GTID Replication on GCPAMYSQL02 - Slave


  b. Set the server as slave and check settings

  ```
  CHANGE MASTER TO
  	MASTER_HOST = '10.1.120.5', > "GCPAMYSQL01 IP"
  	MASTER_PORT = 3306,
  	MASTER_USER = 'slave_user',
  	MASTER_PASSWORD = 'N0t0ca3lCl4rin!',
  	MASTER_AUTO_POSITION = 1;
  ```
  ```
  mysql> show slave status\G
  ```

  c. Start read thread, it will get the binary logs from master and save in the slave filesystem

  `mysql> START SLAVE IO_THREAD`

  d. Check connection and replication IO status, "Slave_IO_State", "Master_Log_File", "Slave_IO_Running"

  `mysql> show slave status\G`

  e. start write thread, it will aply the binaries that came through IO thread

  `mysql> START SLAVE SQL_THREAD`

  f. Check status again

  `mysql> show slave status\G`

  g. Testing the GTID replication and failover.

## Enjoy!
