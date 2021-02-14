#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
# 紫色
magenta='\e[95m'
# 青色
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }
_magenta() { echo -e ${magenta}$*${none}; }
_cyan() { echo -e ${cyan}$*${none}; }


echo "安装MySQL"
echo " ————————————————————"
echo "| author：jsy       |"
echo " ————————————————————"


# 判断Root用户
[[ $(id -u) != 0 ]] && echo -e "\n 哎呀……请使用 ${red}root ${none}用户运行 ${yellow}~(^_^) ${none}\n" && exit 1

# 判断是否有源文件
[[ ! -e /root/app/mysql-5.7.29-el7-x86_64.tar.gz ]] && echo -e "\n 哎呀……文件不存在呀 文件路径： ${red}/root/app/mysql-5.7.29-el7-x86_64.tar.gz ${none} ${yellow}请复制文件(^_^) ${none}\n" && exit 1


echo "开始安装MySQL"

echo "1.解压及创建目录"

# 判断目录存在性
if [[ ! -d "/usr/local" ]]; then
  mkdir -p /usr/local
fi



tar -zxf /root/app/mysql-5.7.29-el7-x86_64.tar.gz -C /usr/local/

mv /usr/local/mysql-5.7.29-el7-x86_64 /usr/local/mysql

MYSQL_HOME=/usr/local/mysql

mkdir ${MYSQL_HOME}/arch ${MYSQL_HOME}/data ${MYSQL_HOME}/tmp

echo "2.创建my.cnf(见文件)  把原来文件的内容全删了再粘贴"
# -f 判断文件存在性 echo 不需要判断
# if [[ ! -f "$file" ]]; then
#   touch "$file"
# fi

echo "
[client]
port            = 3306
socket          = /usr/local/mysql/data/mysql.sock
default-character-set=utf8mb4

[mysqld]
port            = 3306
socket          = /usr/local/mysql/data/mysql.sock

skip-slave-start

skip-external-locking
key_buffer_size = 256M
sort_buffer_size = 2M
read_buffer_size = 2M
read_rnd_buffer_size = 4M
query_cache_size= 32M
max_allowed_packet = 16M
myisam_sort_buffer_size=128M
tmp_table_size=32M

table_open_cache = 512
thread_cache_size = 8
wait_timeout = 86400
interactive_timeout = 86400
max_connections = 600

# Try number of CPU's*2 for thread_concurrency
#thread_concurrency = 32 

#isolation level and default engine 
default-storage-engine = INNODB
transaction-isolation = READ-COMMITTED

server-id  = 1739
basedir     = /usr/local/mysql
datadir     = /usr/local/mysql/data
pid-file     = /usr/local/mysql/data/hostname.pid

#open performance schema
log-warnings
sysdate-is-now

binlog_format = ROW
log_bin_trust_function_creators=1
log-error  = /usr/local/mysql/data/hostname.err
log-bin = /usr/local/mysql/arch/mysql-bin
expire_logs_days = 7

innodb_write_io_threads=16

relay-log  = /usr/local/mysql/relay_log/relay-log
relay-log-index = /usr/local/mysql/relay_log/relay-log.index
relay_log_info_file= /usr/local/mysql/relay_log/relay-log.info

log_slave_updates=1
gtid_mode=OFF
enforce_gtid_consistency=OFF

# slave
slave-parallel-type=LOGICAL_CLOCK
slave-parallel-workers=4
master_info_repository=TABLE
relay_log_info_repository=TABLE
relay_log_recovery=ON

#other logs
#general_log =1
#general_log_file  = /usr/local/mysql/data/general_log.err
#slow_query_log=1
#slow_query_log_file=/usr/local/mysql/data/slow_log.err

#for replication slave
sync_binlog = 500


#for innodb options 
innodb_data_home_dir = /usr/local/mysql/data/
innodb_data_file_path = ibdata1:1G;ibdata2:1G:autoextend

innodb_log_group_home_dir = /usr/local/mysql/arch
innodb_log_files_in_group = 4
innodb_log_file_size = 1G
innodb_log_buffer_size = 200M

#根据生产需要，调整pool size  
innodb_buffer_pool_size = 2G
#innodb_additional_mem_pool_size = 50M #deprecated in 5.6
tmpdir = /usr/local/mysql/tmp

innodb_lock_wait_timeout = 1000
#innodb_thread_concurrency = 0
innodb_flush_log_at_trx_commit = 2

innodb_locks_unsafe_for_binlog=1

#innodb io features: add for mysql5.5.8
performance_schema
innodb_read_io_threads=4
innodb-write-io-threads=4
innodb-io-capacity=200
#purge threads change default(0) to 1 for purge
innodb_purge_threads=1
innodb_use_native_aio=on

#case-sensitive file names and separate tablespace
innodb_file_per_table = 1
lower_case_table_names=1

[mysqldump]
quick
max_allowed_packet = 128M

[mysql]
no-auto-rehash
default-character-set=utf8mb4

[mysqlhotcopy]
interactive-timeout

[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M


" > /etc/my.cnf


echo "3.创建用户组及用户"
sleep 3

groupadd -g 101 dba
useradd -u 514 -g dba -G root -d /usr/local/mysql mysqladmin

echo "4.copy 环境变量配置文件至mysqladmin用户的home目录中"
sleep 3
cp /etc/skel/.* /usr/local/mysql


echo -e "5.修改${red}mysqladmin ${none}环境变量"

echo "export MYSQL_BASE=/usr/local/mysql" >>/usr/local/mysql/.bashrc
echo "export PATH=${MYSQL_BASE}/bin:$PATH" >>/usr/local/mysql/.bashrc

echo "6.赋权限和用户组，切换用户${red}mysqladmin ${none}，安装"
chown  mysqladmin:dba /etc/my.cnf
chmod  640 /etc/my.cnf
chown -R mysqladmin:dba /usr/local/mysql
chmod -R 755 /usr/local/mysql


echo "7.配置服务及开机自启动，应该没生效，有时间了定位下"

cp ${MYSQL_HOME}/support-files/mysql.server /etc/rc.d/init.d/mysql
# #赋予可执行权限
chmod +x /etc/rc.d/init.d/mysql
# 删除服务
chkconfig --del mysql
# 添加服务
chkconfig --add mysql
# 有问题这句话先不用执行
chkconfig --level 345 mysql on


echo -e "8.安装${red}magenta ${none}libaio及安装mysql的初始db"
yum -y install libaio


echo "初始化mysql服务"

${MYSQL_HOME}/bin/mysqld \
--defaults-file=/etc/my.cnf \
--user=mysqladmin \
--basedir=/usr/local/mysql/ \
--datadir=/usr/local/mysql/data/ \
--initialize


echo "# 9.查看临时密码"

tmpPwd=$(cat ${MYSQL_HOME}/data/hostname.err | grep password | awk '{print $11}')

echo -e "临时密码是：${red}${tmpPwd}${none}"

sleep 3

echo "请输入新密码。。。"
read -p "$(echo -e "${cyan}密码${none}:")" password

if [[ -z "${password}" ]]; then
  	echo -e " 
	输入密码有误，输入密码为：${yellow}${password} ${none}
	" && exit 1
fi

echo -e "你输入的密码为：${yellow}${password} ${none}"



echo "# 10.启动    ！！！！！！！！！！！！！一定要登录mysql的用户启动，否则报错"
echo -e "
============= ${red}请执行下面语句${none}===========
${cyan}
su - mysqladmin
service mysql start

mysql -uroot -p'${tmpPwd}'

alter user root@localhost identified by '${password}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${password}';
flush privileges;
exit;

service mysql restart
${none}
"



