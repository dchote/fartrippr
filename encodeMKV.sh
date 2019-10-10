#!/bin/bash

if [ $# -ne 1 ]; then
    echo $0: usage: encodeMKV.sh FILENAME
    exit 1
fi

inputFile=$1
inputExtension="${inputFile##*.}"
inputFilename="${inputFile%.*}"

if [ "$inputExtension" != "mkv" ]; then
  echo $0: file must be .mkv
  exit 1
fi

outputFile="$inputFilename.mp4"

#
# determine which encoder to use by the contentHeight
#
contentHeight="$(ffprobe -v quiet -print_format xml -show_format -show_streams "$inputFile" | xpath -q -e '/ffprobe/streams/stream/@height' | head -n 1)"

if [ "$contentHeight" == ' height="1080"' ]; then
  echo "1080p content"
  
  #
  # determine the correct audio track to use because we can't use truehd in an mp4 container
  #
  firstAudioCodec="$(ffprobe -v quiet -print_format xml -show_format -show_streams "$inputFile" | xpath -q -e '/ffprobe/streams/stream[@codec_type="audio" and @index="1"]/@codec_name')"
  
  if [ "$firstAudioCodec" == ' codec_name="truehd"' ]; then
    HandBrakeCLI --optimize -e nvenc_h264 --encopts="rc-lookahead=0" -a 2,2 -E aac,copy –audio-copy-mask ac3,dts,dtshd -i "$inputFile" -o "$outputFile"
  
  else
    HandBrakeCLI --optimize -e nvenc_h264 --encopts="rc-lookahead=0" -a 1,1 -E aac,copy –audio-copy-mask ac3,dts,dtshd -i "$inputFile" -o "$outputFile"
  
  fi
  
else
  echo "$contentHeight is not 1080p content"
  
  ffmpeg -i "$inputFile" -c:v copy -vtag hvc1 -map 0:0 -map 0:2 -c:a copy "$outputFile"
  
fi