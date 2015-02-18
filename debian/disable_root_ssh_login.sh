#!/bin/bash

set -euo pipefail

sed -i 's/^PermitRootLogin yes$/PermitRootLogin no/' /etc/ssh/sshd_config

service ssh restart