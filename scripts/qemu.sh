#!/bin/sh

# Enclave image to run
EIF=./result/image.eif

# Unix socket created by vhost-device-vsock to connect to
VSOCK_USER_SOCKET=/tmp/vhost4.socket

qemu-system-x86_64 -M nitro-enclave,vsock=c,id=hello-world -kernel ${EIF} -nographic -m 4G --enable-kvm -cpu host -chardev socket,id=c,path=${VSOCK_USER_SOCKET}
