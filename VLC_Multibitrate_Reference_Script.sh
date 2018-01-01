#!/bin/bash
# About:
# -  Real-time reference script to transcode input stream
#    to multiple resolution/bit-rate in parallel
#    with the help of VLC (https://www.videolan.org/vlc/index.html)
# -  Tested on Linux. It must also work on any VLC compatible OS
#    (Windows, Mac,...)
# -  No GUI needed ("-I dummy"). Can be installed as a daemon 
# -  CPU comsumption varies depending on the 
#    number of parallel output streams: 
#       The bigger the internal CPU L1-cache the best.
#    A modern Intel Xeon will probably keep up
#    with 10 or more parallel channels with no major problems.
# 
# Author: Enrique Arizón Benito <enrique.arizon.benito@google.com>

# CONFIGURABLE PARAMS START {
DEBUG="" # -vvv
INPUT="tests/test1.ts"
VCODEC=h264
ACODEC=mp3
WIDTH1=640 ; HEIGHT1=480 ; VB1=800 ;  DST1=127.0.0.1:10001/
WIDTH2=320 ; HEIGHT2=240 ; VB2=400 ;  DST2=127.0.0.1:10002/
WIDTH3=160 ; HEIGHT3=120 ; VB3=200 ;  DST3=127.0.0.1:10003/
# CONFIGURABLE PARAMS END   }

dst1="transcode{width=${WIDTH1},height=${HEIGHT1},vcodec=${VCODEC},acodec=${ACODEC},vb=${VB1},ab=128,deinterlace}:standard{access=http,mux=ts,dst=${DST1}}"
dst2="transcode{width=${WIDTH2},height=${HEIGHT2},vcodec=${VCODEC},acodec=${ACODEC},vb=${VB2},ab=128,deinterlace}:standard{access=http,mux=ts,dst=${DST2}}"
dst3="transcode{width=${WIDTH3},height=${HEIGHT3},vcodec=${VCODEC},acodec=${ACODEC},vb=${VB3},ab=128,deinterlace}:standard{access=http,mux=ts,dst=${DST3}}"

vlc -I dummy ${DEBUG} ${INPUT} --sout "#duplicate{dst=\"${dst1}\",dst=\"${dst2}\",dst=\"${dst3}\"}" &

# Test:
#  vlc "http://DST1" &
#  vlc "http://DST2" &
#  vlc "http://DST3" &
