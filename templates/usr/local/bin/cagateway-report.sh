#!/bin/bash
PID=$(grep 'kill -USR1' /var/run/cagateway-<%= @name %>/gateway.killer | sed 's/.*kill -USR1 \(.*\)/\1/g')
kill -USR1 $PID