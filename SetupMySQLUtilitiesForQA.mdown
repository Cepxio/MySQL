# Install and Setup MySQL Utilities for QA

### Foward from here, need order


mysql> CREATE USER 'utilities'@'10.1.120.%' IDENTIFIED BY 'Uti7I$1M4' PASSWORD EXPIRE NEVER;
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT REPLICATION CLIENT ON *.* TO 'utilities'@'10.1.120.%';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT SUPER ON *.* TO 'utilities'@'10.1.120.%';
Query OK, 0 rows affected (0.01 sec)


# FROM MASTER
[root@gcpamysql01 ~]# mysqlrpladmin --master=root:'IsolationLevel54$'@localhost:3306 --disco=utilities:'Uti7I$1M4' health
WARNING: Using a password on the command line interface can be insecure.
# Discovering slaves for master at localhost:3306
# Discovering slave at 10.1.120.4:3306
# Found slave: 10.1.120.4:3306
# Checking privileges.
#
# Replication Topology Health:
+-------------+-------+---------+--------+------------+---------+
| host        | port  | role    | state  | gtid_mode  | health  |
+-------------+-------+---------+--------+------------+---------+
| localhost   | 3306  | MASTER  | UP     | ON         | OK      |
| 10.1.120.4  | 3306  | SLAVE   | UP     | ON         | OK      |
+-------------+-------+---------+--------+------------+---------+
# ...done.
[root@gcpamysql01 ~]#
[root@gcpamysql01 ~]# mysqlrplshow --master=root:'IsolationLevel54$'@localhost:3306 --disco=utilities:'Uti7I$1M4'  --verbose
WARNING: Using a password on the command line interface can be insecure.
# master on localhost: ... connected.
# Finding slaves for master: localhost:3306

# Replication Topology Graph
localhost:3306 (MASTER)
   |
   +--- 10.1.120.4:3306 [IO: Yes, SQL: Yes] - (SLAVE)
