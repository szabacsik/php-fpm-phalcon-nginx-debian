#!/bin/sh
set -e

if [ $# -gt 0 ]; then
  exec "$@"
else
  php-fpm -D
  exec nginx -g "daemon off;"
fi
