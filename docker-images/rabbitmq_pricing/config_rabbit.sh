#!/bin/bash

# This script needs to be executed just once
if [ -f /$0.completed ] ; then
  echo "$0 `date` /$0.completed found, skipping run"
  exit 0
fi

# Wait for RabbitMQ startup
for (( ; ; )) ; do
  sleep 5
  rabbitmqctl -q node_health_check > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
    echo "$0 `date` rabbitmq is now running"
    break
  else
    echo "$0 `date` waiting for rabbitmq startup"
  fi
done

# Create Rabbitmq user
rabbitmqctl add_vhost local-vh-1 ;
rabbitmqctl add_vhost local-vh-2 ;
rabbitmqctl add_vhost local-vh-3 ;
rabbitmqctl add_user pricing_engine pricing_engine 2>/dev/null ;
rabbitmqctl add_user price price 2>/dev/null ;
rabbitmqctl add_user deal deal 2>/dev/null ;
rabbitmqctl add_user charge charge 2>/dev/null ;
rabbitmqctl add_user empties empties 2>/dev/null ;
rabbitmqctl set_user_tags pricing_engine administrator ;
rabbitmqctl set_user_tags price administrator ;
rabbitmqctl set_user_tags deal administrator ;
rabbitmqctl set_user_tags charge administrator ;
rabbitmqctl set_user_tags empties administrator ;
rabbitmqctl set_permissions -p local-vh-1 pricing_engine  ".*" ".*" ".*" ;
rabbitmqctl set_permissions -p local-vh-2 pricing_engine  ".*" ".*" ".*" ;
rabbitmqctl set_permissions -p local-vh-3 pricing_engine  ".*" ".*" ".*" ;
rabbitmqctl set_permissions -p local-vh-1 price  ".*" ".*" ".*" ;
rabbitmqctl set_permissions -p local-vh-1 deal  ".*" ".*" ".*" ;
rabbitmqctl set_permissions -p local-vh-1 charge  ".*" ".*" ".*" ;
rabbitmqctl set_permissions -p local-vh-1 empties  ".*" ".*" ".*" ;

# Create mark so script is not ran again
touch /$0.completed