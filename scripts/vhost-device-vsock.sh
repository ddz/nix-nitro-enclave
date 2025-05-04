#!/bin/sh

QEMU_SOCKET=/tmp/vhost4.socket

# Separate ports with a '+'
FORWARD_PORTS=8080

readonly guest_cid="guest-cid=4"
readonly forward_cid="forward-cid=1"
readonly forward_listen="forward-listen=${FORWARD_PORTS}"
readonly socket="socket=${QEMU_SOCKET}"

vhost-device-vsock --vm ${guest_cid},${forward_cid},${forward_listen},${socket}
