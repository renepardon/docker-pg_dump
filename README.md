[![GitHub issues](https://img.shields.io/github/issues/renepardon/postgres-db-dump)](https://github.com/renepardon/postgres-db-dump/issues)
[![GitHub forks](https://img.shields.io/github/forks/renepardon/postgres-db-dump)](https://github.com/renepardon/postgres-db-dump/network)
[![GitHub stars](https://img.shields.io/github/stars/renepardon/postgres-db-dump)](https://github.com/renepardon/postgres-db-dump/stargazers)
[![GitHub license](https://img.shields.io/github/license/renepardon/postgres-db-dump)](https://github.com/renepardon/postgres-db-dump/blob/master/LICENSE)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/renepardon/postgres-db-dump)

renepardon/postgres-db-dump
================

Docker image with pg_dump running as a cron task. 
Find the image, here: [renepardon/postgres-db-dump](https://hub.docker.com/r/renepardon/postgres-db-dump/)

## Usage

Attach a target postgres container to this container and mount a volume to container's `/dump` folder. 
Backups will appear in this volume. Optionally set up cron job schedule (default is `0 1 * * *` - runs every day at 1:00 am).

## Environment Variables:
| Variable | Required? | Default | Description |
| -------- |:--------- |:------- |:----------- |
| `PGUSER` | Required | postgres | The user for accessing the database |
| `PGPASSWORD` | Optional | `None` | The password for accessing the database |
| `PGDB` | Optional | postgres | The name of the database |
| `PGHOST` | Optional | db | The hostname of the database |
| `PGPORT` | Optional | `5432` | The port for the database |
| `CRON_SCHEDULE` | Required | 0 1 * * * | The cron schedule at which to run the pg_dump |
| `DELETE_OLDER_THAN` | Optional | `None` | Optionally, delete files older than `DELETE_OLDER_THAN` minutes. Do not include `+` or `-`. |

## Example docker-compose services

```
postgres-backup:
  image: renepardon/postgres-db-dump
  links:
    - postgres:db
  environment:
    - PGUSER=postgres
    - PGPASSWORD=SumPassw0rdHere
    - CRON_SCHEDULE=0 1 * * *
    - DELETE_OLDER_THAN=4320 # Optionally delete files older than $DELETE_OLDER_THAN minutes. 4320 = 3 days
  #  - PGDB=postgres # The name of the database to dump
  #  - PGHOST=postgres # The hostname of the PostgreSQL database to dump
  volumes:
    - /dump
  command: dump-cron
```

Run backup once without cron job, use "mybackup" as backup file prefix, shell will ask for password:

    docker run -ti --rm \
        -v /path/to/local/target/folder:/dump \
        -e PREFIX=mybackup \
        --link my-postgres-container:db \
        renepardon/postgres-db-dump dump

#### Previous Maintainers

- Cristoffer Fairweather <cfairweather@annixa.com>
- Ilya Stepanov <dev@ilyastepanov.com>
