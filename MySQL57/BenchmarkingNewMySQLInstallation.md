# Phase 3
## Benchmark a New Server is core to know if our RDBMS can suply the required levels in performance.

### Create test db and tables to benchmarks and them make some test. 

+ Connect to the MySQL Server

	```
	[root@localhost src]# mysql -u root -p -h 127.0.0.1 --show-warnings

	```
+ Execute the script [database_schema_lab.sql]()
	It contains everything.


[Note]: We will do this test with a table model following the recomendations from MySQL
[Note]: For more and detailed information see https://dev.mysql.com/doc/refman/5.7/en/innodb-best-practices.html

### Download and install Sysbench

+ Akopytov give us a bash script for a easy installation.

	```
	[root@localhost src]# curl -O https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh 
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100  6396    0  6396    0     0   4486      0 --:--:--  0:00:01 --:--:--  4488
	```

+ Change the perms to the shell script

	```
	[root@localhost src]# chmod 740 script.rpm.sh 
	[root@localhost src]# ll
	total 8
	-rwxr----- 1 root root 6396 Oct 25 15:03 script.rpm.sh
	```
	
+ The script will detect the OS, Distro, Version and install the repository, so Execute the script!

	```
	[root@localhost src]# ./script.rpm.sh 
	Detected operating system as rhel/7.
	Checking for curl...
	Detected curl...
	Downloading repository file: https://packagecloud.io/install/repositories/akopytov/sysbench/config_file.repo?os=rhel&dist=7&source=script
	done.
	Installing pygpgme to verify GPG signatures...
	Loaded plugins: product-id, search-disabled-repos, subscription-manager
	akopytov_sysbench-source/signature                                                             |  836 B  00:00:00     
	Retrieving key from https://packagecloud.io/akopytov/sysbench/gpgkey
	Importing GPG key 0x04DCFD39:
	 Userid     : "https://packagecloud.io/akopytov/sysbench-prerelease (https://packagecloud.io/docs#gpg_signing) <support@packagecloud.io>"
	 Fingerprint: 9789 8d69 f99e e5ca c462 a0f8 cf10 4890 04dc fd39
	 From       : https://packagecloud.io/akopytov/sysbench/gpgkey
	akopytov_sysbench-source/signature                                                             | 1.0 kB  00:00:00 !!! 
	mysql-connectors-community                                                                     | 2.5 kB  00:00:00     
	mysql-tools-community                                                                          | 2.5 kB  00:00:00     
	mysql57-community                                                                              | 2.5 kB  00:00:00     
	rhel-7-server-optional-rpms                                                                    | 3.5 kB  00:00:00     
	rhel-7-server-rpms                                                                             | 3.5 kB  00:00:00     
	rhel-7-server-rt-beta-rpms                                                                     | 4.0 kB  00:00:00     
	rhel-7-server-rt-rpms                                                                          | 4.0 kB  00:00:00     
	(1/6): rhel-7-server-rt-rpms/7Server/x86_64/updateinfo                                         |  66 kB  00:00:01     
	(2/6): rhel-7-server-rt-rpms/7Server/x86_64/primary_db                                         | 105 kB  00:00:00     
	(3/6): rhel-7-server-optional-rpms/7Server/x86_64/updateinfo                                   | 1.7 MB  00:00:02     
	(4/6): rhel-7-server-rpms/7Server/x86_64/updateinfo                                            | 2.4 MB  00:00:02     
	(5/6): rhel-7-server-optional-rpms/7Server/x86_64/primary_db                                   | 6.1 MB  00:00:04     
	(6/6): rhel-7-server-rpms/7Server/x86_64/primary_db                                            |  44 MB  00:00:21     
	akopytov_sysbench-source/primary                                                               | 1.1 kB  00:00:10     
	akopytov_sysbench-source                                                                                          4/4
	Package pygpgme-0.3-9.el7.x86_64 already installed and latest version
	Nothing to do
	Installing yum-utils...
	Loaded plugins: product-id, search-disabled-repos, subscription-manager
	Resolving Dependencies
	--> Running transaction check
	---> Package yum-utils.noarch 0:1.1.31-42.el7 will be installed
	--> Processing Dependency: python-kitchen for package: yum-utils-1.1.31-42.el7.noarch
	--> Running transaction check
	---> Package python-kitchen.noarch 0:1.1.1-5.el7 will be installed
	--> Processing Dependency: python-chardet for package: python-kitchen-1.1.1-5.el7.noarch
	--> Running transaction check
	---> Package python-chardet.noarch 0:2.2.1-1.el7_1 will be installed
	--> Finished Dependency Resolution
	
	Dependencies Resolved
	
	======================================================================================================================
	 Package                      Arch                 Version                     Repository                        Size
	======================================================================================================================
	Installing:
	 yum-utils                    noarch               1.1.31-42.el7               rhel-7-server-rpms               117 k
	Installing for dependencies:
	 python-chardet               noarch               2.2.1-1.el7_1               rhel-7-server-rpms               227 k
	 python-kitchen               noarch               1.1.1-5.el7                 rhel-7-server-rpms               266 k
	
	Transaction Summary
	======================================================================================================================
	Install  1 Package (+2 Dependent packages)
	
	Total download size: 610 k
	Installed size: 2.8 M
	Downloading packages:
	(1/3): python-chardet-2.2.1-1.el7_1.noarch.rpm                                                 | 227 kB  00:00:00     
	(2/3): python-kitchen-1.1.1-5.el7.noarch.rpm                                                   | 266 kB  00:00:00     
	(3/3): yum-utils-1.1.31-42.el7.noarch.rpm                                                      | 117 kB  00:00:00     
	----------------------------------------------------------------------------------------------------------------------
	Total                                                                                 436 kB/s | 610 kB  00:00:01     
	Running transaction check
	Running transaction test
	Transaction test succeeded
	Running transaction
	  Installing : python-chardet-2.2.1-1.el7_1.noarch                                                                1/3 
	  Installing : python-kitchen-1.1.1-5.el7.noarch                                                                  2/3 
	  Installing : yum-utils-1.1.31-42.el7.noarch                                                                     3/3 
	  Verifying  : python-chardet-2.2.1-1.el7_1.noarch                                                                1/3 
	  Verifying  : yum-utils-1.1.31-42.el7.noarch                                                                     2/3 
	  Verifying  : python-kitchen-1.1.1-5.el7.noarch                                                                  3/3 
	
	Installed:
	  yum-utils.noarch 0:1.1.31-42.el7                                                                                    
	
	Dependency Installed:
	  python-chardet.noarch 0:2.2.1-1.el7_1                      python-kitchen.noarch 0:1.1.1-5.el7                     
	
	Complete!
	Generating yum cache for akopytov_sysbench...
	Importing GPG key 0x04DCFD39:
	 Userid     : "https://packagecloud.io/akopytov/sysbench-prerelease (https://packagecloud.io/docs#gpg_signing) <support@packagecloud.io>"
	 Fingerprint: 9789 8d69 f99e e5ca c462 a0f8 cf10 4890 04dc fd39
	 From       : https://packagecloud.io/akopytov/sysbench/gpgkey
	
	The repository is setup! You can now install packages.
	```
	
+ Now we are ready to install sysbench

	```
	[root@localhost src]# yum search sysbench
	Loaded plugins: product-id, search-disabled-repos, subscription-manager
	=============================================== N/S matched: sysbench ================================================
	sysbench-debuginfo.x86_64 : Debug information for package sysbench
	sysbench.x86_64 : Scriptable database and system performance benchmark
	
	  Name and summary matches only, use "search all" for everything.
	[root@localhost src]# 
	[root@localhost src]# 
	[root@localhost src]# 
	[root@localhost src]# yum install sysbench
	Loaded plugins: product-id, search-disabled-repos, subscription-manager
	akopytov_sysbench/x86_64/signature                                                             |  836 B  00:00:00     
	akopytov_sysbench/x86_64/signature                                                             | 1.0 kB  00:00:00 !!! 
	akopytov_sysbench-source/signature                                                             |  836 B  00:00:00     
	akopytov_sysbench-source/signature                                                             | 1.0 kB  00:00:00 !!! 
	Resolving Dependencies
	--> Running transaction check
	---> Package sysbench.x86_64 0:1.0.9-1.el7.centos will be installed
	--> Processing Dependency: libpq.so.5()(64bit) for package: sysbench-1.0.9-1.el7.centos.x86_64
	--> Running transaction check
	---> Package postgresql-libs.x86_64 0:9.2.23-1.el7_4 will be installed
	--> Finished Dependency Resolution
	
	Dependencies Resolved
	
	======================================================================================================================
	 Package                     Arch               Version                          Repository                      Size
	======================================================================================================================
	Installing:
	 sysbench                    x86_64             1.0.9-1.el7.centos               akopytov_sysbench              362 k
	Installing for dependencies:
	 postgresql-libs             x86_64             9.2.23-1.el7_4                   rhel-7-server-rpms             233 k
	
	Transaction Summary
	======================================================================================================================
	Install  1 Package (+1 Dependent package)
	
	Total download size: 596 k
	Installed size: 1.6 M
	Is this ok [y/d/N]: y
	Downloading packages:
	(1/2): postgresql-libs-9.2.23-1.el7_4.x86_64.rpm                                               | 233 kB  00:00:00     
	(2/2): sysbench-1.0.9-1.el7.centos.x86_64.rpm                                                  | 362 kB  00:00:01     
	----------------------------------------------------------------------------------------------------------------------
	Total                                                                                 308 kB/s | 596 kB  00:00:01     
	Running transaction check
	Running transaction test
	Transaction test succeeded
	Running transaction
	  Installing : postgresql-libs-9.2.23-1.el7_4.x86_64                                                              1/2 
	  Installing : sysbench-1.0.9-1.el7.centos.x86_64                                                                 2/2 
	  Verifying  : postgresql-libs-9.2.23-1.el7_4.x86_64                                                              1/2 
	  Verifying  : sysbench-1.0.9-1.el7.centos.x86_64                                                                 2/2 
	
	Installed:
	  sysbench.x86_64 0:1.0.9-1.el7.centos                                                                                
	
	Dependency Installed:
	  postgresql-libs.x86_64 0:9.2.23-1.el7_4                                                                             
	
	Complete!
	```


