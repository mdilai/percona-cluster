FROM ubuntu:14.04
MAINTAINER Maksym Dilai <admin@dproject.org.ua>

ENV DEBIAN_FRONTEND noninteractive

# Upgrade
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

# setup repos
RUN echo "deb http://repo.percona.com/apt trusty main" >> /etc/apt/sources.list.d/percona.list
RUN echo "deb-src http://repo.percona.com/apt trusty main" >> /etc/apt/sources.list.d/percona.list
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
RUN apt-get update

# install packages
RUN apt-get install -y percona-xtradb-cluster-56 qpress xtrabackup
RUN apt-get install -y python-software-properties host socat unzip ca-certificates wget curl netcat hostname --no-install-recommends --no-install-suggests
# install galera-healthcheck
RUN wget -O /bin/galera-healthcheck 'https://github.com/sttts/galera-healthcheck/releases/download/v20150303/galera-healthcheck_linux_amd64'
RUN test "$(sha256sum /bin/galera-healthcheck | awk '{print $1;}')" = "86f60d9d82b1f9d2d474368ed7e81a0a361508031a292244847136b0ed2ee770"
RUN chmod +x /bin/galera-healthcheck

# configure mysqld
RUN sed -i 's/#? *bind-address/# bind-address/' /etc/mysql/my.cnf
RUN sed -i 's/#? *log-error/# log-error/' /etc/mysql/my.cnf
ADD conf.d/utf8.cnf /etc/mysql/conf.d/utf8.cnf
ADD conf.d/galera.cnf /etc/mysql/conf.d/galera.cnf
RUN chmod 0644 /etc/mysql/conf.d/utf8.cnf
RUN chmod 0644 /etc/mysql/conf.d/galera.cnf

EXPOSE 3306 4444 4567 4568
VOLUME ["/var/lib/mysql"]
COPY mysqld.sh /mysqld.sh
COPY start /start
RUN chmod 555 /start /mysqld.sh
ENTRYPOINT ["/start"]
