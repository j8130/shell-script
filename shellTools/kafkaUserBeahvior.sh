#!/bin/bash

# 自动生成kafka消息脚本

rate=$1

if [[ -z "$rate" ]]; then
  rate=1
fi

echo rate is $rate

java -cp /export/server/kafka/flink-learn-1.0-SNAPSHOT.jar com.jsy.aaa.SourceGenerator 1 | /export/server/kafka/bin/kafka-console-producer.sh --broker-list node1:9092,node2:9092,node3:9092 --topic user_behavior
