#!/bin/sh

socat VSOCK-CONNECT:1:8080 TCP-LISTEN:8080,fork
