FROM ubuntu:20.04 

RUN apt update -y && apt upgrade -y

# Shift timezone to Asia/Tokyo.
#RUN apt-get install -y tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*
#ENV TZ Asia/Tokyo
RUN apt-get install -y tzdata
ENV TZ Asia/Tokyo

# install vcf2rdf 
RUN apt-get install -y wget unzip
RUN mkdir -p bin && \
    wget https://github.com/togovar/vcf2rdf/releases/download/v1.0.0-beta.8/vcf2rdf-x86_64-unknown-linux-gnu.zip && \
    unzip vcf2rdf-x86_64-unknown-linux-gnu.zip && \
    mv vcf2rdf ./bin
