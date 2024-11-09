#!/bin/bash

get_rabbit_node_env_value () {
  temp_hostname_env_var="RABBITMQ_NODE$1_HOSTNAME";
  rabbitmq_node_env_value="${!temp_hostname_env_var}"
}

echo "@BetterWeb/docker-rabbitmq-cluster: Cluster bootup";

if [ -e "/var/lib/rabbitmq/.erlang.cookie" ]; then
  chown rabbitmq:rabbitmq -v /var/lib/rabbitmq/.erlang.cookie;
  chmod 600 /var/lib/rabbitmq/.erlang.cookie;
fi 

if [ -e "/etc/rabbitmq/conf.d/10-defaults.conf" ]; then
    if [[ "${RABBITMQ_NO_DEFAULT_CONFIG,,}" == "true" ]] || [[ "${RABBITMQ_NO_DEFAULT_CONFIG,,}" == "yes" ]]; then
        echo "@BetterWeb/docker-rabbitmq-cluster: Removing default config file"
        rm /etc/rabbitmq/conf.d/10-defaults.conf
    fi
fi

echo "@BetterWeb/docker-rabbitmq-cluster: Listing config files in conf.d:"
for config_file in /etc/rabbitmq/conf.d/*; do
    if [ -f "$config_file" ]; then
        echo "  - $(basename "$config_file")"
    fi
done

echo "@BetterWeb/docker-rabbitmq-cluster: Resetting permissions"
chown rabbitmq:rabbitmq -Rv /var/lib/rabbitmq/;
chmod 600 -Rv /etc/rabbitmq/conf.d

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
