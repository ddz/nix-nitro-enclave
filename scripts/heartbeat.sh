#!/bin/sh

#
# The enclave init sends a heartbeat (b7) byte over a vsock to
# port 9000 on the primary instance and expects the same byte back
# in order to proceed with its launch.
#

# Create an unnamed pipe for reading and writing as an echo server
socat -x VSOCK-LISTEN:9000,fork PIPE
