#!/bin/bash

get_rabbit_node_env_value () {
  temp_hostname_env_var="RABBITMQ_NODE$1_HOSTNAME";
  rabbitmq_node_env_value="${!temp_hostname_env_var}"
}

echo "@BetterWeb/docker-rabbitmq-cluster: Cluster bootup";

if [ -e "/var/lib/rabbitmq/.erlang.cookie" ]; then
  chmod 600 /var/lib/rabbitmq/.erlang.cookie;
fi 

echo "@BetterWeb/docker-rabbitmq-cluster: Resetting permissions"
chown rabbitmq:rabbitmq -Rv /var/lib/rabbitmq/;

cluster_node_number=1
get_rabbit_node_env_value "${cluster_node_number}";
while [ ! -z "${rabbitmq_node_env_value}" ]
do
  echo "@BetterWeb/docker-rabbitmq-cluster: Linking node: ${cluster_node_number}=${rabbitmq_node_env_value}";
  cluster_command_line="cluster_formation.classic_config.nodes.${cluster_node_number} = ${rabbitmq_node_env_value}";
  echo -e $cluster_command_line >> /etc/rabbitmq/rabbitmq.conf;

  cluster_node_number=$((cluster_node_number+1));
  get_rabbit_node_env_value "${cluster_node_number}";
done

echo "@BetterWeb/docker-rabbitmq-cluster: Ready with $((cluster_node_number+-1)) node(s)";

rabbitmq-server;
