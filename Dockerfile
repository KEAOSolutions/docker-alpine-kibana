# Kibana image
FROM gliderlabs/alpine:edge

# Kibana version
ARG KIBANA_VERSION=4.5.0-linux-x64
ENV KIBANA_VERSION ${KIBANA_VERSION}
ARG KIBANA_DOWNLOAD_URL=https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}.tar.gz
ENV KIBANA_DOWNLOAD_URL ${KIBANA_DOWNLOAD_URL}
ENV KIBANA_HOME=/usr/share/kibana
ENV PATH=${PATH}:${KIBANA_HOME}/bin

# Install NodeJS and Kibana
RUN apk add --update nodejs curl
RUN curl -s ${KIBANA_DOWNLOAD_URL} | tar zx -C /usr/share && \
    ln -s /usr/share/kibana-${KIBANA_VERSION} $KIBANA_HOME && \
    rm -rf /usr/share/kibana/node && \
    mkdir -p /usr/share/kibana/node/bin && \
    ln -sf /usr/bin/node /usr/share/kibana/node/bin/node && \
    echo -ne "- with Kibana `kibana -V`\n" >> /root/.built
ADD config /usr/share/kibana/config
RUN apk del curl && \
    rm -rf /var/cache/apk/*

# Expose default port
EXPOSE 5601

# Run Kibana in node.js
ENTRYPOINT ["kibana"]

