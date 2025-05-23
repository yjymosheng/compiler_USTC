FROM ubuntu:latest

LABEL maintainer="yjymosheng@gmail.com"

RUN apt update && apt upgrade -y \
    && apt install -y build-essential clang llvm flex bison cmake make zlib1g-dev libzstd-dev gdb \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

COPY dockerfiles/loongarch64-clfs-3.0-cross-tools-gcc-glibc.tar.xz /opt/
COPY dockerfiles/qemu-6.2.50.loongarch64.tar.gz /opt/
COPY dockerfiles/gdb.tar.gz /opt/
COPY dockerfiles/test-env.tar.gz /opt/

# 解压工具链到 /opt
RUN tar xaf /opt/loongarch64-clfs-3.0-cross-tools-gcc-glibc.tar.xz -C /opt \
    && tar xaf /opt/qemu-6.2.50.loongarch64.tar.gz -C /opt \
    && tar xaf /opt/gdb.tar.gz -C /opt \
    && tar xaf /opt/test-env.tar.gz -C /opt \
    && rm -f /opt/*.tar.*

# 将工具路径加入环境变量
ENV PATH="$PATH:/opt/cross-tools.gcc_glibc/bin:/opt/gdb/bin:/opt/qemu/bin"

WORKDIR /workspace

CMD [ "bash" ]
