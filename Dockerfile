ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update

RUN apt-get install -y git build-essential cmake m4 ninja-build python3 curl clang  gcc g++ python build-essential opam ocaml checkinstall python-pygments python-yaml llvm

#COPY workarea /workarea
######### start:  pull in building ###########
WORKDIR /workarea
# llvm 15.0
ARG LLVM_VERSION=09629215c272f09e3ebde6cc7eac9625d28910ff
# go1.18
ARG LLVMGO_VERSION=3452ec6bebaa1b432aabed1991475f4444c1775e
ARG GOFRONTEND_VERSION=1c5bfd57131b68b91d8400bb017f35d416f7aa7b
ARG LIBBACKTRACK_VERSION=fd9442f7b5413e7788dfcf356f6261afcedb56e8
ARG LIBFFI_VERSION=2e825e219fa06d308b9a9863d70320606d67490d

RUN git clone https://github.com/llvm/llvm-project.git && cd llvm-project && git checkout ${LLVM_VERSION}

RUN cd llvm-project/llvm/tools && \
    git clone https://go.googlesource.com/gollvm && cd gollvm && git checkout ${LLVMGO_VERSION} && \
    git clone https://go.googlesource.com/gofrontend && cd gofrontend && git checkout ${GOFRONTEND_VERSION} && cd ../libgo && \
    git clone https://github.com/libffi/libffi.git && cd libffi && git checkout ${LIBFFI_VERSION} && cd .. && \
    git clone https://github.com/ianlancetaylor/libbacktrace.git && cd libbacktrace && git checkout ${LIBBACKTRACK_VERSION}
######## end: pull in building ##############
WORKDIR /workarea/build.rel
RUN cmake -DCMAKE_INSTALL_PREFIX=/goroot -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_LINKER=gold -G Ninja ../llvm-project/llvm
RUN ninja gollvm
RUN ninja install-gollvm

ENV LD_LIBRARY_PATH=/workarea/build.rel/tools/gollvm/libgo
ARG LD_LIBRARY_PATH=/goroot/lib64
RUN export PATH=/tmp/gollvm-install/bin:$PATH
RUN go version
