#!/usr/bin/env bash

case ${INFO} in
0)
	ICON=""
	;;
[0-9])
	ICON=""
	;;
*)
	ICON=""
	;;
esac

sketchybar --set "$NAME" icon="$ICON" label="$INFO%"
