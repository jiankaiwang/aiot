FROM ubuntu:latest

LABEL maintainer="JianKai Wang <GLjankai@gmail.com>"

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get update && \
    apt-get install -y curl

RUN apt-get install -y gnupg2 && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    apt-get update && \
    apt-get install -y edgetpu-compiler

CMD tail -f /dev/null