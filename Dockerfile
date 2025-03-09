FROM ubuntu:latest

LABEL maintainer="yjymosheng@gmail.com"

RUN apt update && apt upgrade -y \
    && apt install -y build-essential clang llvm flex bison cmake make zlib1g-dev libzstd-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD [ "bash" ]
