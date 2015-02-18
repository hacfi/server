#!/bin/bash

set -eu

sed -i 's/^PermitRootLogin yes$/PermitRootLogin no/' /etc/ssh/sshd_config

service ssh restart