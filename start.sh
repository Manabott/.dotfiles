#!/usr/bin/env bash

# initialize wallpaper daemon
swww init &
# set wallpaper
swww img ~/.dotfiles/hypr/wallpapers/1.jpg &

# networking
nm-applet --indicator &

# Waybar
waybar &

# Notification daemon
dunst
