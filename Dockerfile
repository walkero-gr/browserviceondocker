ARG CPU

FROM phusion/baseimage:master-${CPU}

LABEL maintainer="Georgios Sokianos <walkero@gmail.com>"

EXPOSE 8080

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update && apt-get -y install \
    wget \
    curl \
    cmake \
    g++ \
    pkg-config \
    libxcb1-dev \
    libx11-dev \
    libpoco-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpango1.0-dev \
    libpangoft2-1.0-0 \
    ttf-mscorefonts-installer \
    xvfb \
    xauth \
    libatk-bridge2.0-0 \
    libasound2 \
    libgbm1 \
    libxi6 \
    libcups2 \
    libnss3 \
    libxcursor1 \
    libxrandr2 \
    libxcomposite1 \
    libxss1 \
    libxkbcommon0; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN curl -fsSL https://github.com/ttalvitie/browservice/archive/refs/tags/v0.9.2.0.tar.gz -o /tmp/browservice.tar.gz; \
    cd /tmp; \
    tar xvfz browservice.tar.gz; \
    cd browservice-0.9.2.0/; \
    ./download_cef.sh && ./setup_cef.sh; \
    make -j2; \
    chown root:root release/bin/chrome-sandbox && chmod 4755 release/bin/chrome-sandbox; \
    mv release/ /; \
    cd /; \
    rm -rf /tmp/* /var/tmp/*;

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV BROWSRV_USER_ID=1000
ENV BROWSRV_GROUP_ID=1000

# Add browsrv user and group
RUN existing_group=$(getent group "${BROWSRV_GROUP_ID}" | cut -d: -f1); \
    if [[ -n "${existing_group}" ]]; then delgroup "${existing_group}"; fi; \
    existing_user=$(getent passwd "${BROWSRV_USER_ID}" | cut -d: -f1); \
    if [[ -n "${existing_user}" ]]; then deluser "${existing_user}"; fi; \
    addgroup --gid ${BROWSRV_GROUP_ID} browsrv; \
    adduser --system --uid ${BROWSRV_USER_ID} --disabled-password --shell /bin/bash --gid ${BROWSRV_GROUP_ID} browsrv; \
    sed -i '/^browsrv/s/!/*/' /etc/shadow; 

RUN chown ${BROWSRV_USER_ID}:${BROWSRV_GROUP_ID} /release -R; \
    chown root:root /release/bin/chrome-sandbox && chmod 4755 /release/bin/chrome-sandbox

USER browsrv

WORKDIR /release/bin/
