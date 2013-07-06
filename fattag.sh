#!/bin/bash
#
# "Forked" it from
# http://sam.nipl.net/code/nipl-tools/bin/fattag
#
# Label a vfat device, such as an SD card or USB stick.
# It uses mlabel, from mtools.

set -e

device="$1"
label="$2"
if [ -z "$device" -o "${device#-}" != "$device" ]; then
    prog=`basename "$0"`
    echo >&2 "usage: $prog device [label]"
    echo >&2 "fat devices:"
    blkid | sed -n '/fat/{ s/^/  /; p; }'
    exit 2
fi
bak=0
trap '
    status=$?
    if [ $bak = 1 ]; then
        mv ~/.mtoolsrc.bak.$$ ~/.mtoolsrc
    else
        rm -f ~/.mtoolsrc
    fi
    exit $status
' INT QUIT TERM PIPE EXIT
if [ -e ~/.mtoolsrc ]; then
    bak=1
    mv ~/.mtoolsrc ~/.mtoolsrc.bak.$$
fi
echo "mtools_skip_check=1" >~/.mtoolsrc
if [ -z "$label" ]; then
    mlabel -i ${device} -s :: | sed 's/^ Volume label is //; s/ *$//;'
else
    mlabel -i ${device} -s "::${label}"
    sync
fi
