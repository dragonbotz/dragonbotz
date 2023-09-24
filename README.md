# Prerequisites
To build the project, you need to install the followings softwares first:
- [make](https://www.gnu.org/software/make/)
- [git](https://git-scm.com/)
- [docker](https://www.docker.com/)

## Volumes
To create the service's volumes you need to run the following command:
```bash
$ make init
```

# Quick Build
To build the whole project, run the following commands:
```bash
$ make services -j
$ make init -j
$ make clear -j
```

## Character service
To build the character service, run:
```bash
$ make character-service
```

## Portal service
To build the portal service, run:
```bash
$ make portal-service
```

## Cleaning builder images
Builder images are heavy, it is recommended to remove those if you do not need 
them anymore.

To do so, please run the following command:
```bash
$ make clear -j
```

# Database configuration
Each service's database must run on its own port. Here's the list of databases and their corresponding ports:
- **dbz-character-database**: `5432`
- **dbz-portal-database**   : `5433`

To change databases configuration you need to run the following commands:
```bash
$ docker compose up -d                          # Starts the services and their database
$ docker exec -it <SERVICE_NAME>-database bash  # Attach your terminal to the service
```
Then edit `/var/lib/postgresql/data/postgres.conf` and change the value of `port` to the proper value (discussed above).

# Troubleshooting
## Database init
The database initialization process may fail and display an error message similar to this:
```
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: No such file or directory
	Is the server running locally and accepting connections on that socket?
```
To fix this, you might want to run the following command:
```bash
$ make init
```
In most cases running `make init` again fixes the issue.

If the problem persists, don't hesitate to open an **issue**.
