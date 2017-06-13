FROM nginx:1.13.1

RUN apt-get update \
    && apt-get install -y -q --no-install-recommends --no-install-suggests \
    wget \
    net-tools \
    tzdata \
    ca-certificates \
    && mkdir -p /data \
    && mkdir -p /etc/nginx/sites-enabled/

ADD conf/nginx-site.conf /etc/nginx/sites-enabled/nginx-site.conf
ADD conf/nginx.conf /nginx.conf

ADD scripts/getVersion.sh /getVersion.sh

WORKDIR /data
RUN /bin/bash /getVersion.sh 1235.6.0
RUN /bin/bash /getVersion.sh 1353.7.0
RUN /bin/bash /getVersion.sh 1353.8.0

EXPOSE 80
CMD ["nginx", "-c","/nginx.conf"]
