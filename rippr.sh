#!/bin/bash

mount /dev/sr0 /mnt

sleep 5

title="$(xpath -q -e '/disclib/di:discinfo/di:title/di:name/text()' /mnt/BDMV/META/DL/bdmt_eng.xml)"
title=${title/' - Blu-ray™'/''}
title=${title/' - Blu-ray'/''}

echo "Disc title is: $title"

umount /dev/sr0

if [ -n "$title" ]; then
    rip_path="/content/$title"
    mkdir -p rip_path
    echo "Path is: $rip_path"
    
    makemkvcon --minlength=3600 -r --decrypt --directio=true mkv disc:0 all $rip_path
fi

eject