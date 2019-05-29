#!/bin/bash

BGR="wt-logo.png"
CPWD=$PWD
BASE_PATH="$CPWD/tmp/orgs-commits-video/"
LOGS="$CPWD/tmp/logs/"
REPO_LIST="$CPWD/tmp/repo-list.txt"

mkdir -p "$BASE_PATH"
while read item
do
  if [ -d "$BASE_PATH$item" ]; then
     cd "$BASE_PATH$item"
     git pull
     cd ..
  else
     git clone "git@github.com:$ORGANIZATION/$item" "$BASE_PATH$item"
  fi
  cd "$CPWD"
  gource --output-custom-log "$LOGS$item.log" "$BASE_PATH$item"
done < "$REPO_LIST"



cd "$CPWD"
cat "$LOGS"*".log" | grep -v '\[bot\]' | sort -n > "${LOGS}combined.log"
gource "${LOGS}combined.log" \
  --auto-skip-seconds 2 \
  --seconds-per-day 1 \
  --file-idle-time 0 \
  --background-image "$BGR" \
  --highlight-users \
  --highlight-colour 0B8FDF \
  --output-framerate 60 \
  --hide mouse \
  --time-scale 4 \
  -1280x720 \
-o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 gource.mp4
