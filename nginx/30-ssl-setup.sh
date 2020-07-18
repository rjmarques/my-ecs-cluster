#!/bin/sh

set -e

ME=$(basename $0)

echo "$ME: starting up nginx" 1>&2

nginx

echo "$ME: running certbot to create new certificates for nginx" 1>&2

certbot --nginx -n --agree-tos --email contact@ricardomarques.dev --no-eff-email -d ricardomarques.dev -d www.ricardomarques.dev -d something.ricardomarques.dev --staging

echo "$ME: turning nginx off - ssl configuration set" 1>&2

nginx -s quit

echo "$ME: creating a cron job for certificate renewal" 1>&2

echo "0 12 * * * /usr/bin/certbot renew --quiet --staging" | crontab -

exit 0