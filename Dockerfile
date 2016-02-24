FROM ubuntu

MAINTAINER LionHeart <LionHeart_fxc@163.com>

ENV FASTDHT_PATH=/FastDHT \
    FASTDHT_BASE_PATH=/dht_data \
    BERKELEY_DB_VERSION=6.1.26

RUN apt-get update && apt-get install -y \
    gcc \
    git \
    make \
    wget

RUN mkdir -p ${FASTDHT_PATH}/fastdht \
 && mkdir -p ${FASTDHT_BASE_PATH} \
 && mkdir -p ${FASTDHT_PATH}/libfastcommon \
 && mkdir -p ${FASTDHT_PATH}/download

RUN git clone https://github.com/happyfish100/libfastcommon.git ${FASTDHT_PATH}/libfastcommon \
 && git clone https://github.com/happyfish100/fastdht.git ${FASTDHT_PATH}/fastdht \
 && wget "http://download.oracle.com/berkeley-db/db-${BERKELEY_DB_VERSION}.tar.gz" -P ${FASTDHT_PATH}/download \
 && tar zxvf /fastDFS/download/db-${BERKELEY_DB_VERSION}.tar.gz -C ${FASTDHT_PATH}/download

WORKDIR ${FASTDHT_PATH}/libfastcommon

RUN ["/bin/bash", "-c", "./make.sh && ./make.sh install"]

WORKDIR ${FASTDHT_PATH}/fastdht

RUN ["/bin/bash", "-c", "./make.sh && ./make.sh install"]

WORKDIR ${FASTDHT_PATH}/download/db-${BERKELEY_DB_VERSION}/build_unix

RUN ../dist/configure --prefix=/usr \
 && make \
 && make install

WORKDIR ${FASTDHT_PATH}/fastdht

RUN ["/bin/bash", "-c", "./make.sh && ./make.sh install"]

EXPOSE 11411
