#FROM ckleinsc/baseimage-kasmvnc-python
FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble
# set version label
LABEL maintainer="Luka <lukajerkovic@protonmail.com>"
# environment settings
ENV \
       TITLE="KCC" \
       GIT_REPO="https://github.com/ciromattia/kcc" \
       GIT_BRANCH="master" \
       CUSTOM_PORT=$CUSTOM_PORT \
       HOME="/config" \
       NO_DECOR=1 \
       PIP_BREAK_SYSTEM_PACKAGES=1 \
       QTWEBENGINE_DISABLE_SANDBOX="1"

# install system dependencies
RUN apt-get update
RUN apt-get install -y \
        gcc \
        cmake \
        unzip \
        unrar \
        p7zip-full \
        p7zip-rar \
        libpng-dev \
        libjpeg-dev \
        git \
        libnss3 \
        libopengl0 \
        libxkbcommon-x11-0 \
        libxcb-cursor0 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-randr0 \
        libxcb-render-util0 \
        libxcb-xinerama0 \
        python3 \
        python3-xdg \
        python3-pip \
        python3-dev \
        libjpeg-dev

# install kindlegen
COPY files/ /tmp
RUN tar zxvf /tmp/kindlegen*tar.gz -C /usr/local/bin

# install KCC
WORKDIR /app
RUN git clone -b $GIT_BRANCH $GIT_REPO .
RUN pip install -r requirements.txt

# clean up
RUN  apt-get remove -y \
       gcc \
       cmake \
       git \
       python3-pip \
       python3-dev
RUN  apt-get clean && \
       rm -rf \
              /tmp/* \
              /var/lib/apt/lists/* \
              /var/tmp/*

# set autostart default
RUN echo "python3 /app/kcc.py" >  /defaults/autostart
