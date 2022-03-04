FROM ubuntu:focal

# Copy files to container
COPY . .

# Some basic environment variables
ENV HOME=/home/app \
    PUID=1000 \
    PGID=1000 \
    HTTP_PORT=8080 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    VNC_PASSWORD=password

# Installing base packages
RUN set -xe && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bash \
        novnc \
        x11vnc \
        xvfb \
        fluxbox \
        supervisor

# User setup
RUN set -xe && \
    groupadd --gid ${PGID} app && \
    useradd --create-home --home-dir "${HOME}" --shell /bin/bash --uid ${PUID} --gid ${PGID} app

WORKDIR ${HOME}

EXPOSE ${HTTP_PORT}

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]

# Installing Wine
ENV LC_ALL=en_US

# Installing additional packages for additional repos
RUN set -xe && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
        gnupg \
        lsb-release \
        locales && \
    locale-gen en_US

RUN set -xe && \
    wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - && \
    echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        winehq-stable=6.0.3~focal-1 \
        wine-stable=6.0.3~focal-1 \
        wine-stable-amd64=6.0.3~focal-1 \
        wine-stable-i386=6.0.3~focal-1

# Installing MSSQL
ENV ACCEPT_EULA=Y

RUN set -xe && \
    wget -nv -O- https://packages.microsoft.com/keys/microsoft.asc | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - && \
    echo "deb https://packages.microsoft.com/ubuntu/$(lsb_release -sr)/mssql-server-2019 $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    echo "deb https://packages.microsoft.com/ubuntu/$(lsb_release -sr)/prod $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
            mssql-server \
            mssql-tools \
            unixodbc \
            libodbc1 \
            msodbcsql18

# Removing apt cache
RUN set -xe && \
    rm -rf /var/lib/apt/lists/*

# Installing Bee-Up
ENV WINEARCH=win64 \
    WINEPREFIX="${HOME}/.wine_adoxx" \
    WINEDEBUG=-all \
    TOOLFOLDER=BEEUP16_ADOxx_SA \
    DATABASE_HOST=127.0.0.1 \
    DATABASE=beeup16_64 \
    SA_PASSWORD=12+*ADOxx*+34 \
    LICENSE_KEY=zAd-nvkz-Ynrtvrht9IAL2pZ \
    LC_ALL=en_US

RUN set -xe && \
    locale-gen en_US && \
    mkdir -p "${HOME}/data" && \
    mkdir -p "${WINEPREFIX}/drive_c/Program Files/BOC/" && \
    cp -rf "beeup/setup64/BOC/${TOOLFOLDER}" "${WINEPREFIX}/drive_c/Program Files/BOC/" && \
    cp -rf beeup/support64/*.sql "${HOME}/" && \
    cp -rf beeup/*.adl "${HOME}/" && \
    rm -rf beeup/ && \
    chmod +x "${HOME}/start_app.sh" && \
    chmod +x "${HOME}/start_mssql.sh" && \
    chown -R ${PUID}.${PGID} "${HOME}"

VOLUME ${HOME}/data
