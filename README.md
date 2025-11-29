## Start


```bash
  #run dev mode:
  docker compose -f compose.yml up
```

## Backup

fill all tables from backup file

```bash
  #copy backup file to docker container
  docker cp ./backup-28.11.sql nest-postgres:/tmp/backup.sql

  #create table
  docker exec -it nest-postgres psql -U postgres -c "CREATE DATABASE $YOUR_PG_DB(NOT POSTGRES!);"

  #restore from backup file
  docker exec -it nest-postgres psql -U postgres -d $YOUR_PG_DB(NOT POSTGRES!) -f /tmp/backup.sql

  #remove tmp backup file in docker
  docker exec -it nest-postgres rm /tmp/backup.sql
```

