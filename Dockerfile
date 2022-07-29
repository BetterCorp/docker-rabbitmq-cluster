ARG RABBIT_C_VERSION=latest

FROM rabbitmq:$RABBIT_C_VERSION

COPY ./rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
COPY ./startup.sh /etc/rabbitmq/startup.sh

CMD ["bash", "/etc/rabbitmq/startup.sh"]