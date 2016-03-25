FROM ubuntu

MAINTAINER LionHeart <LionHeart_fxc@163.com>

ENV FASTDHT_PATH=/FastDHT
ENV FASTDHT_BASE_PATH=/dht_data
ENV BERKELEY_DB_VERSION=6.1.26

RUN apt-get update 
RUN apt-get install -y gcc
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y wget

RUN mkdir -p ${FASTDHT_PATH}/fastdht \
RUN mkdir -p ${FASTDHT_BASE_PATH} \
RUN mkdir -p ${FASTDHT_PATH}/libfastcommon \
RUN mkdir -p ${FASTDHT_PATH}/download

RUN git clone https://github.com/happyfish100/libfastcommon.git ${FASTDHT_PATH}/libfastcommon
RUN git clone https://github.com/happyfish100/fastdht.git ${FASTDHT_PATH}/fastdht
RUN wget "http://download.oracle.com/berkeley-db/db-${BERKELEY_DB_VERSION}.tar.gz" -P ${FASTDHT_PATH}/download
RUN tar zxvf ${FASTDHT_PATH}/download/db-${BERKELEY_DB_VERSION}.tar.gz -C ${FASTDHT_PATH}/download

WORKDIR ${FASTDHT_PATH}/download/db-${BERKELEY_DB_VERSION}/build_unix

RUN ../dist/configure --prefix=/usr 
RUN make
RUN make install

WORKDIR ${FASTDHT_PATH}/libfastcommon

RUN ["/bin/bash", "-c", "./make.sh"]
RUN ["/bin/bash", "-c", "./make.sh install"]
  
WORKDIR ${FASTDHT_PATH}/fastdht

RUN ["/bin/bash", "-c", "./make.sh"]
RUN ["/bin/bash", "-c", "./make.sh install"]

EXPOSE 11411
