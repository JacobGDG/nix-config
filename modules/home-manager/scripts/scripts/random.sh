#!/usr/bin/env bash

length=${1:-32}
head_length=$((length + 16))

head -c $head_length /dev/urandom  | base64 | tr '+/' 'AB' | tr -d '\n' | tr -d '=' | head -c $length
