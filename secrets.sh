#!/bin/bash

# This script de encrypt a "gpc encrypted , then base64 encoded" string ,
# asks for a password, shows in vim, and automatically kills the vim "visor"
# after "SECONDS_TO_DISPLAY".
# The base64 string is generated like:
#     | (
#     | cat << END_OF_SECRETS
#     | mysecret01
#     | mysecret02
#     | mysecret03
#     | END_OF_SECRETS
#     | )| gpg -d --batch --passphrase 1234 | base64
#                   ┌──────────────────┴──┘
#                  ┌┴─┐
echo "Use password 1234 for this demo"
SECONDS_TO_DISPLAY=5

read -p "Password Please: " -s PASS
(  
  (
cat << EOF
jA0ECQMCB8DHie5vpcr/0kYBq8PUgBsoy50IbCshtYDR5xYqeqIq+TztxH6IxSVfWY/9+KpVq59F
R+wlqy912MaRf1pIO2JHfBmpFi0LK6yzqZZiwzqO
EOF
  ) | base64 -d | gpg -d --batch --passphrase ${PASS}
) | vim - &
PID=$!
sleep ${SECONDS_TO_DISPLAY} && kill $PID
reset
