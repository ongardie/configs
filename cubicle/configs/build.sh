#!/bin/sh
set -eu

tar -c --verbatim-files-from --files-from provides.txt -f ~/provides.tar
