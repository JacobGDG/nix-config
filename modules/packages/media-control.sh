#!/usr/bin/env bash

volume_step=5
mic_volume_step=5
brightness_step=5
max_volume=100
mic_max_volume=100
notification_timeout=1000
download_album_art=true
show_album_art=true
show_music_in_volume_indicator=true
app_name="Media Control"

function get_volume {
  pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mute {
  pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

function get_mic_volume {
  pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mic_mute {
  pactl get-source-mute @DEFAULT_SOURCE@ | grep -Po '(?<=Mute: )(yes|no)'
}

function get_brightness {
  declare -i absb
  absb=$(brightnessctl g)
  maxb=$(brightnessctl m)
  absb=$((absb * 100))
  echo $((absb / maxb))
}

function get_volume_icon {
  volume=$(get_volume)
  mute=$(get_mute)
  if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
    volume_icon=" "
  elif [ "$volume" -lt 50 ]; then
    volume_icon=" "
  else
    volume_icon=" "
  fi
}

function get_mic_icon {
  mute=$(get_mic_mute)
  if [ "$mute" == "yes" ]; then
    mic_icon="󰍭 "
  else
    mic_icon=" "
  fi
}

function get_brightness_icon {
  brightness_icon=""
}

function get_album_art {
  url=$(playerctl -f "{{mpris:artUrl}}" metadata)
  if [[ $url == "file://"* ]]; then
    album_art="${url/file:\/\//}"
  elif [[ $url == "http://"* ]] && [[ $download_album_art == "true" ]]; then
    filename="$(echo "$url" | sed "s/.*\///")"
    if [ ! -f "/tmp/$filename" ]; then
      wget -O "/tmp/$filename" "$url"
    fi
    album_art="/tmp/$filename"
  elif [[ $url == "https://"* ]] && [[ $download_album_art == "true" ]]; then
    filename="$(echo "$url" | sed "s/.*\///")"
    if [ ! -f "/tmp/$filename" ]; then
      wget -O "/tmp/$filename" "$url"
    fi
    album_art="/tmp/$filename"
  else
    album_art=""
  fi
}

function show_volume_notif {
  volume=$(get_volume)
  get_volume_icon
  if [[ $show_music_in_volume_indicator == "true" ]]; then
    current_song=$(playerctl -f "{{title}} - {{artist}}" metadata)
    if [[ $show_album_art == "true" ]]; then
      get_album_art
    fi
    notify-send -a "$app_name" -t $notification_timeout -h string:x-dunst-stack-tag:volume_notif -h int:value:"$volume" -i "$album_art" "$volume_icon $volume%" "$current_song"
  else
    notify-send -a "$app_name" -t $notification_timeout -h string:x-dunst-stack-tag:volume_notif -h int:value:"$volume" "$volume_icon $volume%"
  fi
}

function show_music_notif {
  song_title=$(playerctl -f "{{title}}" metadata)
  song_artist=$(playerctl -f "{{artist}}" metadata)
  song_album=$(playerctl -f "{{album}}" metadata)
  if [[ $show_album_art == "true" ]]; then
    get_album_art
  fi
  notify-send -a "$app_name" -t $notification_timeout -h string:x-dunst-stack-tag:music_notif -i "$album_art" "$song_title" "$song_artist - $song_album"
}

function show_mic_notif {
  volume=$(get_mic_volume)
  get_mic_icon
  notify-send -a "$app_name" -t $notification_timeout -h string:x-dunst-stack-tag:mic_volume_notif -h int:value:"$volume" "$mic_icon $volume%"
}

function show_brightness_notif {
  brightness=$(get_brightness)
  get_brightness_icon
  notify-send -a "$app_name" -t $notification_timeout -h string:x-dunst-stack-tag:brightness_notif -h int:value:"$brightness" "$brightness_icon $brightness%"
}

case $1 in
volume_up)
  pactl set-sink-mute @DEFAULT_SINK@ 0
  volume=$(get_volume)
  if [ $(("$volume" + "$volume_step")) -gt $max_volume ]; then
    pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
  else
    pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
  fi
  show_volume_notif
  ;;
volume_down)
  pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
  show_volume_notif
  ;;
volume_mute)
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  show_volume_notif
  ;;
brightness_up)
  brightnessctl s +$brightness_step%
  show_brightness_notif
  ;;
brightness_down)
  brightnessctl s $brightness_step%-
  show_brightness_notif
  ;;
next)
  playerctl next
  sleep 0.5 && show_music_notif
  ;;
prev)
  playerctl previous
  sleep 0.5 && show_music_notif
  ;;
play_pause)
  playerctl play-pause
  show_music_notif
  ;;
mic_up)
  pactl set-source-mute @DEFAULT_SOURCE@ 0
  mic_volume=$(get_mic_volume)
  if [ $(("$mic_volume" + "$mic_volume_step")) -gt $mic_max_volume ]; then
    pactl set-source-volume @DEFAULT_SOURCE@ $mic_max_volume%
  else
    pactl set-source-volume @DEFAULT_SOURCE@ +$mic_volume_step%
  fi
  show_mic_notif
  ;;
mic_down)
  pactl set-source-volume @DEFAULT_SOURCE@ -$mic_volume_step%
  show_mic_notif
  ;;
mic_mute)
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
  show_mic_notif
  ;;
esac
