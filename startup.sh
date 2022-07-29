#!/bin/bash

get_rabbit_node_env_value () {
  temp_hostname_env_var="RABBITMQ_NODE$1_HOSTNAME";
  rabbitmq_node_env_value="${!temp_hostname_env_var}"
}

echo "@BETTERCORP/RABBITMQ: CLUSTER BOOTUP SEQ";

cluster_node_number=1
get_rabbit_node_env_value "${cluster_node_number}";
while [ ! -z "${rabbitmq_node_env_value}" ]
do
  echo "@BETTERCORP/RABBITMQ: CLUSTER BOOTUP SEQ: ${cluster_node_number}=${rabbitmq_node_env_value}";
  cluster_command_line="cluster_formation.classic_config.nodes.${cluster_node_number} = ${rabbitmq_node_env_value}";
  echo -e $cluster_command_line >> /etc/rabbitmq/rabbitmq.conf;

  cluster_node_number=$((cluster_node_number+1));
  get_rabbit_node_env_value "${cluster_node_number}";
done

echo "@BETTERCORP/RABBITMQ: CLUSTER BOOTUP SEQ: READY WITH $((cluster_node_number+-1)) NODE(S)";

rabbitmq-server;