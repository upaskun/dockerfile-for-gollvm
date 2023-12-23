# dockerfile-for-gollvm

## Description
A dockerfile for creating a gollvm container environment.

You can pull llvm-project while building or use script `create_workarea.sh` to download the project on your host and use `COPY` while building image.

I only test on my Ubuntu 22.04.3 LTS with docker 24.0.7.

## Reference
1. https://groups.google.com/g/golang-nuts/c/EzY7FFlDINM
2. https://github.com/creack/docker-gollvm/
3. https://github.com/victorybringer/gollvm-docker
