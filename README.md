# Percona XtraDB cluster for Docker

Based on https://github.com/sttts/docker-galera-mariadb-10.0

```bash
$ docker run -d -v /data:/var/lib/mysql -p 3306:3306 -p 8080:8080 \
    --net=host -e XTRABACKUP_PASSWORD=abc -e MYSQL_ROOT_PASSWORD=secret \
    mdilai/percona-cluster seed

$ docker run -d -v /data:/var/lib/mysql -p 3306:3306 -p 8080:8080 \
    mdilai/percona-cluster --net=host \
    -e XTRABACKUP_PASSWORD=abc \
    node 172.17.0.81,172.17.0.97

$ docker run -d -v /data:/var/lib/mysql -p 3306:3306 -p 8080:8080 \
    mdilai/percona-cluster --net=host \
    -e XTRABACKUP_PASSWORD=abc \
    node 172.17.0.81 --any-mysql-argument-you-like
```
