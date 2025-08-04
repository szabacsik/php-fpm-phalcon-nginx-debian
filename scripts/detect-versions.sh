#!/bin/bash
set -e

php_version=$(php -v | head -n1 | cut -d" " -f2)
[ -n "$php_version" ] || { echo "PHP version detection failed!" >&2; exit 1; }

phalcon_version=$(php -d display_errors=0 -r "echo phpversion('phalcon');")
[ -n "$phalcon_version" ] || { echo "Phalcon is missing or version detection failed!" >&2; exit 1; }

nginx_version=$(nginx -v 2>&1 | cut -d"/" -f2)
[ -n "$nginx_version" ] || { echo "Nginx version detection failed!" >&2; exit 1; }

debian_version=$(cat /etc/debian_version 2>/dev/null || echo "")
[ -n "$debian_version" ] || { echo "Debian version detection failed!" >&2; exit 1; }

if [ "$1" == "--json" ]; then
  echo "{\"php\": \"$php_version\", \"phalcon\": \"$phalcon_version\", \"nginx\": \"$nginx_version\", \"debian\": \"$debian_version\"}"
elif [ "$1" == "--tag" ]; then
  echo "php${php_version}-phc${phalcon_version}-ng${nginx_version}-deb${debian_version}"
else
  echo "Usage: $0 [--json|--tag]" >&2
  exit 2
fi
