#!/bin/bash

sed -i "s/nginx\!/${HOSTNAME}/g" /usr/share/nginx/html/index.html

exec "$@"
