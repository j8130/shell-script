# 一键安装脚本

需要把支持文件放到 `/root/app` 目录下



## jdk

~~~shell
bash <(curl -s -k -L https://raw.githubusercontent.com/j8130/shell-script/master/OneKeyInstall/jdkInstaller.sh)
~~~

## MySQL

~~~shell
bash <(curl -s -k -L https://raw.githubusercontent.com/j8130/shell-script/master/OneKeyInstall/mysqlInstaller.sh)
~~~







## 常用操作

~~~shell
# 获取前一天的日期 如 20200101
day=`date -d '1 days ago'"+%Y%m%d"`
echo day

# HOME_DIR=`dirname $0`

~~~

