# set version label
LABEL maintainer="Luka <lukajerkovic@protonmail.com>"

FROM ckleinsc/baseimage-kasmvnc-python

# environment settings
ENV \
       TITLE="KCC" \
       GIT_REPO="https://github.com/ciromattia/kcc" \
       GIT_BRANCH="master"

# install system dependencies
RUN apt-get install -y \
       unzip \
       unrar \
       p7zip-full \
       p7zip-rar \
       libpng-dev \
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
