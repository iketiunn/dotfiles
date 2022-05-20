ffmpeg \
  -re -fflags +genpts \
  -stream_loop -1 \
  -i ~/Downloads/dog.mp4 \
  -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -g 50 \
  -c:a aac -b:a 160k -ac 2 -ar 44100 \
  -f flv \
  -force_key_frames 'expr:gte(t,n_forced*1)' -flags +cgop \
  -vf drawtext=fontfile=roboto.ttf:text='%{localtime}':fontsize=40:fontcolor=white@0.8:x=250:y=200 \
  rtmp://127.0.0.1:1935/live/rK2BF72XSvuBXeYqWBiDE
