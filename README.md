# docker-rabbitmq-cluster

Simple config based rabbitMQ cluster with management.  

Define env vars for each node to link:  

```-e RABBITMQ_NODE{node number}_HOSTNAME={full node path}```  

Example:  
RABBITMQ_NODE1_HOSTNAME=ampq://node1  
RABBITMQ_NODE2_HOSTNAME=ampq://node2

