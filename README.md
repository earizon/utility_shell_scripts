# Utility scripts
Keep it simple and stupid utility scripts for different/useful/random tasks
   
 * node_wrapper.sh: Another KISS script to run node inside docker containers. Commands like
   `npm install`
   become
   `./node_wrapper.sh npm install`
   
   `NODE_VERSION` indicates what version of node to use. (latest by default)
   
 * q :
   `q <file_pattern> <text_pattern>` will grep for <text_pattern> in any file in 
   the current directory and subfolder whose file name matches <file_pattern>.  
   <text_pattern> can be a regular expression. 
   Example 1: Search for any "*model*js" file (case insensitive) matching the regex
   "id.*index"
   
       `cd src ; q "*model*js" "id.*index"`
   
 * VLC_Multibitrate_Reference_Script.sh: KISS reference script that takes any input video and streams in parallel
   to different screens and bitrate resolutions using the world famous VLC. 
   It can be used to stream video through low-bandth-width or saturated networks.

