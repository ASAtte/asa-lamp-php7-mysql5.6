# LAMP

CentOS7, PHP7, MySQL5.6

## Build

MySQL rootパスワードのデフォルト値はpassword
```
$ docker build -t name:latest .
```

## Run

```
$ docker volume create datadir
$ docker run -d -p 80:80 -p 3340:3340 -v datadir:/var/lib/mysql --rm name:latest
```
