FROM rabbitmq:3.8-management

COPY ./rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
COPY ./startup.sh /etc/rabbitmq/startup.sh

CMD ["bash", "/etc/rabbitmq/startup.sh"]
