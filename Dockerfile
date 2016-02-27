FROM ubuntu

MAINTAINER LionHeart <LionHeart_fxc@163.com>

ENV FASTDHT_PATH=/FastDHT \
    FASTDHT_BASE_PATH=/dht_data \
    BERKELEY_DB_VERSION=6.1.26

RUN apt-get update && apt-get install -y \
    gcc \
    git \
    make \
    wget \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${FASTDHT_PATH}/fastdht \
 && mkdir -p ${FASTDHT_BASE_PATH} \
 && mkdir -p ${FASTDHT_PATH}/libfastcommon \
 && mkdir -p ${FASTDHT_PATH}/download
 
WORKDIR ${FASTDHT_PATH}/libfastcommon

RUN /bin/bash -c 'git clone https://github.com/happyfish100/libfastcommon.git ${FASTDHT_PATH}/libfastcommon ;\
  ./make.sh ;\
  ./make.sh install ;\
  rm -rf ${FASTDHT_PATH}/libfastcommon'
  
WORKDIR ${FASTDHT_PATH}/download/db-${BERKELEY_DB_VERSION}/build_unix

RUN /bin/bash -c 'wget "http://download.oracle.com/berkeley-db/db-${BERKELEY_DB_VERSION}.tar.gz" -P ${FASTDHT_PATH}/download ;\
  tar zxvf ${FASTDHT_PATH}/download/db-${BERKELEY_DB_VERSION}.tar.gz -C ${FASTDHT_PATH}/download ;\
  ../dist/configure --prefix=/usr ;\
  make ;\
  make install ;\
  rm -rf ${FASTDHT_PATH}/download'

WORKDIR ${FASTDHT_PATH}/fastdht

RUN /bin/bash -c 'git clone https://github.com/happyfish100/fastdht.git ${FASTDHT_PATH}/fastdht ;\
  ./make.sh ;\
  ./make.sh install ;\
  rm -rf ${FASTDHT_PATH}/fastdht'

EXPOSE 11411
