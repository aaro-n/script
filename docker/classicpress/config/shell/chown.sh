#!/bin/bash

sleep 7

# 从文件中读取环境变量
source /home/www/docker_env

echo "NGINX_ROOT_HTML: ${NGINX_ROOT_HTML}"

if [[ "${NGINX_ROOT_HTML}" == *"/public" ]]; then
    chown -R www-data:www-data "$(echo ${NGINX_ROOT_HTML%/public})"
else
    chown -R www-data:www-data "${NGINX_ROOT_HTML}"
fi
