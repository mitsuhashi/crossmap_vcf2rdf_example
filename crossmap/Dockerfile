FROM ubuntu:20.04 

RUN apt update -y && apt upgrade -y

# Shift timezone to Asia/Tokyo.
#RUN apt-get install -y tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*
#ENV TZ Asia/Tokyo
RUN apt-get install -y tzdata
ENV TZ Asia/Tokyo

# Set local to jp.
#RUN apt-get update && apt-get install -y language-pack-ja && \
   #update-locale LANG=ja_JP.UTF-8 && rm -rf /var/lib/apt/lists/*
#ENV LANG ja_JP.UTF-8
#ENV LANGUAGE ja_JP:ja
#ENV LC_ALL ja_JP.UTF-8

# install python
RUN apt install -y python3
RUN apt install -y python3-dev python3-pip python3-setuptools
RUN python3 -m pip install --upgrade pip setuptools

# install crossmap
# http://crossmap.sourceforge.net/#installation
RUN apt install -y libbz2-dev liblzma-dev tabix 
RUN pip3 install CrossMap --upgrade        #upgrade CrossMap supporting Python3

# install vcftools 
RUN apt-get install -y vcftools

# install bcftools 
RUN apt-get install -y bcftools 
