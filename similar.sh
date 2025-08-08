similar for linux command
```
mkdir -p mp3 && for file in *.wav; do ffmpeg -i "$file" -vn -ar 44100 -ac 1 -b:a 64k "mp3/${file%.wav}.mp3"; done
```
