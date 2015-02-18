#!/bin/bash

set -euo pipefail

sed -i 's/^de_DE.UTF-8 UTF-8$/# de_DE.UTF-8 UTF-8/' /etc/locale.gen

locale-gen --purge en_US.UTF-8
update-locale LANG=en_US.UTF-8
