#!/bin/bash

echo "kafka 群起脚本"

case $1 in
"start"){
    for i in node1 node2 node3
    do
        echo "=============$i================"
        ssh $i "/export/server/kafka/bin/kafka-server-start.sh -daemon /export/server/kafka/config/server.properties"
    done
};;
"stop"){
    for i in node1 node2 node3
    do
        echo "=============$i================"
        ssh $i "/export/server/kafka/bin/kafka-server-stop.sh"
    done
};;
*)
    echo Invalid Args!
    echo 'Usage: '$(basename $0)' start|stop'
    ;;
esac
