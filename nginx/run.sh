#!/bin/sh

set -e

ME=$(basename $0)

echo "$ME: running certbot after nginx startsup, to create new certificates for nginx"

# the container should be hooked to the nginx process
# so we run certbot with a little delay to ensure it runs after nginx started
(sleep 5 ; certbot --nginx -n --agree-tos --email contact@ricardomarques.dev --no-eff-email --expand -d ricardomarques.dev,www.ricardomarques.dev,something.ricardomarques.dev --redirect) &

service cron start

echo "$ME: starting nginx"

nginx -g "daemon off;"