### 4K UHD (AppleTV compatible)
ffmpeg -i INPUT -c:v copy -vtag hvc1 -map 0:0 -map 0:2 -c:a copy OUTPUT

### General encode
HandBrakeCLI --optimize -e nvenc_h264 --encopts="rc-lookahead=0" -a 1,1 -E aac,copy –audio-copy-mask ac3,dts,dtshd -i INPUT -o OUTPUT

OR

ffmpeg -vsync 0 -hwaccel cuvid -c:v h264_cuvid -i INPUT -c:v h264_nvenc -preset slow -map 0:0 -map 0:1 -map 0:1 -c:a:0 aac -c:a:1 copy OUTPUT


