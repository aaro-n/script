# 使用基础镜像
FROM debian:stable-slim

# 设置默认环境变量
ARG TIMEZONE=Asia/Shanghai
ENV TZ=$TIMEZONE
ENV NGINX_ROOT_HTML=/home/www/html/classicpress
ENV NGINX_PORT=8080
ENV PHP_VERSION=8.1

# 添加SURY PHP PPA存储库并安装PHP
RUN apt-get update && apt-get install -y --no-install-recommends wget apt-transport-https lsb-release ca-certificates \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    nginx \
#    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-tidy \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-apcu \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-redis \ 
    php${PHP_VERSION}-gd \
    cron \
    s6 \
    tzdata \
    curl \
    daemontools \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && chmod +x /usr/local/bin/wp \
    && mkdir -p /home/www/html \
    && mkdir -p /home/www/nginx \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && dpkg --remove --force-depends systemd

# 将S6配置文件复制到容器
COPY config/s6 /etc/s6
# 将定时任务复制到容器
COPY config/crontab /etc/cron.d/crontab
# 将Nginx复制到容器
COPY config/nginx/nginx.conf /etc/nginx/sites-enabled/default
COPY config/nginx/conf /home/www/nginx
# 复制脚本
COPY config/shell /root/shell

# 创建PHP目录
RUN  mkdir -p /run/php/ \
    # 为PHP目录赋予权限
    && chmod -R 755 /run/php/ \
    # 为S6赋予权限
    && chmod -R 755 /etc/s6 \
    # 为脚本赋予执行权限
    && chmod -R 755 /root/shell \
    # 为定时任务赋予权限
    && chmod 0644 /etc/cron.d/crontab

WORKDIR /home/www

# 启动s6-svscan作为入口命令
CMD ["s6-svscan", "/etc/s6"]

