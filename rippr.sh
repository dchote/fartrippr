#!/bin/bash
rip_target="/content/Processing"

echo "Mounting to determine title"

mkdir -p /mnt/sr0
mount /dev/sr0 /mnt/sr0

sleep 1

if [ -f "/mnt/sr0/BDMV/META/DL/bdmt_eng.xml" ]; then
  title="$(xpath -q -e '/disclib/di:discinfo/di:title/di:name/text()' /mnt/sr0/BDMV/META/DL/bdmt_eng.xml)"
  size=${#title}

  if [ "$size" -gt "3" ]; then
    title=${title/'™'/''}
    title=${title/' - Blu-ray'/''}
    title=${title/' – Blu-ray'/''}
    title=${title/' - 4K Ultra HD'/''}
    title="${title// /_}"
    title="${title/$'\n'/_}"
    
    tar czf "/tmp/$title.tar.gz" -C /mnt/sr0/BDMV/META/DL .
    echo "Disc title via META is: $title"
  else
    unset title
  fi
  
fi

if [ ! "$title" ]; then
  title="$(blkid -o value -s LABEL /dev/sr0)"
  title="${title// /_}"
  
  if [ -n "$title" ]; then
    echo "Disc title via LABEL: $title"
    
    if [ "$title" == "LOGICAL_VOLUME_ID" ]; then
      title="$(blkid -p -o value -s VOLUME_ID /dev/sr0)"
      title="${title// /_}"
      echo "Disc title via LOGICAL_VOLUME_ID: $title"
    fi
  fi
fi

umount /dev/sr0

if [ -n "$title" ]; then
  rip_path="$rip_target/$title"
  mkdir -p $rip_path
  echo "Output path is: $rip_path"

  if [ -f "/tmp/$title.tar.gz" ]; then
    cp --no-preserve=mode,ownership "/tmp/$title.tar.gz" "$rip_path/meta.tar.gz"
    rm "/tmp/$title.tar.gz"
  fi

  makemkvcon --minlength=2800 -r --decrypt --directio=true mkv disc:0 all $rip_path
else
  echo "** No title Found **"
fi


#eject
