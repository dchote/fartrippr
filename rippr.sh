#!/bin/bash
rip_target="/content/Processing"

echo "Mounting to determine title"

mkdir -p /mnt/sr0
mount /dev/sr0 /mnt/sr0

sleep 1

if [ -f "/mnt/sr0/BDMV/META/DL/bdmt_eng.xml" ]; then

  title="$(xpath -q -e '/disclib/di:discinfo/di:title/di:name/text()' /mnt/sr0/BDMV/META/DL/bdmt_eng.xml)"
  title=${title/'™'/''}
  title=${title/' - Blu-ray'/''}
  title=${title/' - 4K Ultra HD'/''}
  title="${title// /_}"

  tar czf "/tmp/$title.tar.gz" -C /mnt/sr0/BDMV/META/DL .

  echo "Disc title is: $title"

  umount /dev/sr0

  if [ -n "$title" ]; then
    rip_path="$rip_target/$title"
    mkdir -p $rip_path
    echo "Path is: $rip_path"

    if [ -f "/tmp/$title.tar.gz" ]; then
      cp --no-preserve=mode,ownership "/tmp/$title.tar.gz" "$rip_path/meta.tar.gz"
      rm "/tmp/$title.tar.gz"
    fi

    makemkvcon --minlength=3600 -r --decrypt --directio=true mkv disc:0 all $rip_path
  fi
fi

#eject