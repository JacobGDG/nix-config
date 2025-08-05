#!/usr/bin/env bash

length=${1:-32}

head -c 100 /dev/urandom | base64 | tr '+/' 'AB' | tr -d '=' | head -c $length
