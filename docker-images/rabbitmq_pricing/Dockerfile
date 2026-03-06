FROM rabbitmq:3.8-management-alpine
ADD ca_certificate.pem /etc/rabbitmq/ca_certificate.pem
ADD server_certificate.pem /etc/rabbitmq/server_certificate.pem
ADD server_key.pem /etc/rabbitmq/server_key.pem
ADD rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
ADD init.sh /init.sh
ADD config_rabbit.sh /config_rabbit.sh
RUN chmod +x /init.sh /config_rabbit.sh
ENTRYPOINT ["/init.sh"]
