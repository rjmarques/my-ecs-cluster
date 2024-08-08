FROM nginx:1.19

RUN apt-get update

RUN apt-get install -y software-properties-common \
    && add-apt-repository ppa:certbot/certbot

RUN apt-get install -y gpg certbot python-certbot-nginx cron

COPY nginx.conf /etc/nginx/nginx.conf

COPY run.sh /run.sh

ENTRYPOINT ["/bin/bash"]
CMD ["./run.sh"]