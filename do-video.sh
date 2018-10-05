#!/bin/bash

ORGANIZATION="windingtree"
BGR="wt-logo.png"
BASE_PATH='/tmp/orgs-commits-video/'
CPWD=$PWD
LOGS="$CPWD/logs/"
REPOS=(`curl "https://api.github.com/orgs/$ORGANIZATION/repos" | /usr/bin/python -c 'import sys, json; data = json.load(sys.stdin); names = [d["name"] for d in data]; print(json.dumps(names))' | tr -d '[],"'`)

mkdir -p "$BASE_PATH"
for item in ${REPOS[*]}
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
done

cd "$CPWD"
cat "$LOGS"*".log" | sort -n > "$LOGScombined.log"
gource "$LOGScombined.log" --auto-skip-seconds 2 --seconds-per-day 1 --file-idle-time 0 --key --background-image "$BGR" --highlight-users --highlight-colour 0B8FDF --output-framerate 60 --hide mouse --time-scale 4 -1280x720 \
-o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 gource.mp4
