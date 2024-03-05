# Medical Exams API

This is a Ruby API that provides access to medical exams data. It uses Sinatra as the web framework and PostgreSQL as the database, all installed inside docker containers.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed the latest version of [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

## Running the API

Be sure to not having a postgresql service running on your machine in port 5432. You can check it by typing the following command:
```sh
sudo lsof -i :5432
```

If yes, it will show you the process id of the service.
```sh
COMMAND    PID     USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
postgres 14087 postgres    3u  IPv4 126791      0t0  TCP localhost:postgresql (LISTEN)
```

Type the following command to stop it:
```sh
sudo systemctl stop postgresql
```

To run the API, follow these steps:

1. Clone this repository.
2. Navigate to the project directory.
3. Run the following commands:

Change the permissions of bin/dev to make it executable
```sh
chmod +x bin/dev
```

To start the application with Docker Compose (Recommended), because it's easier to see the logs:
```sh
bin/dev start_compose
```

Or to start the application with Docker CLI only:

```sh
bin/dev start_docker
```

To stop the application with Docker CLI only:

```sh
bin/dev stop_docker
```

To stop the application with Docker Compose:

```sh
bin/dev stop_compose
```

To rebuild the application with Docker Compose:

```sh
bin/dev rebuild_compose
```

To rebuild the application with Docker CLI only:

```sh
bin/dev rebuild_docker
```

The command `bin/dev start_compose` or `bin/dev start_docker` will start two Docker containers: one for the PostgreSQL database and one for the Ruby/Sinastra API. The API will be available at `http://localhost:3000`.

Firstly, the database will be created and be connected. 
This message will be on the console for a while if you are using the `bin/dev start_compose` command:

```sh
db-1   | 2024-03-04 17:02:25.373 UTC [36] LOG:  database system is ready to accept connections
```

if you are using the `bin/dev start_docker` command, to see the message above, you need to run logs command:

```sh 
docker logs medical_exams_db
```

After this, the database will be seeded with some data.

Then, the API will be started. In the console, you will see the API logs. You will be granted access to the API once you see this message. It could take a while to see it:

```sh
Puma starting in single mode...
app-1  | * Puma version: 6.4.2 (ruby 3.2.3-p157) ("The Eagle of Durango")
app-1  | *  Min threads: 0
app-1  | *  Max threads: 5
app-1  | *  Environment: development
app-1  | *          PID: 8
app-1  | * Listening on http://0.0.0.0:3000
app-1  | Use Ctrl-C to stop
```

If you are not using compose, to see this log message, you can run the following command:

```sh
docker logs medical_exams_app
```

## View containers information

To view the containers information, run:

```sh
docker ps
```

## Accessing the Containers

To access the Ruby API container, run:

```sh
docker exec -it medical_exams_app bash
```
Replace `<container_id>` with the ID of the Ruby API container. You can get the container ID by running `docker ps`.

## Accessing the Database

To access the PostgreSQL database, run:

```sh
docker exec -it medical_exams_db psql -U postgres
```

## View container logs

To view the logs of the containers, run:

```sh
docker logs <container_name>
```

if you started the containers with `bin/dev start_compose`, you can use the following command to view the logs of the containers:

```sh
docker compose logs
```

## Running the Tests

To run the tests, you need to access the Ruby API container as described above. Then, run:

```sh
bundle exec rspec
```

## Making Requests to the /tests Endpoint

You can make GET requests to the `/tests` endpoint to retrieve medical exams data. Here's an example using curl:

```sh
curl http://localhost:3000/tests
```

This will return a JSON array with the medical exams data.

```json
[
  {
    "cpf": "048.973.170-88",
    "name": "Maria Luiza Pires",
    "email": "denna@wisozk.biz",
    "birth_date": "2001-03-11",
    "address": "165 Rua Rafaela",
    "city": "Ituverava",
    "state": "Alagoas",
    "crm": "B000BJ20J4",
    "crm_state": "PI",
    "id": "1",
    "patient_cpf": "048.973.170-88",
    "doctor_crm": "B000BJ20J4",
    "token": "IQCZ17",
    "exam_date": "2021-08-05",
    "exam_type": "hemácias",
    "exam_limits": "45-52",
    "exam_result": "97"
  },
  {
    "cpf": "048.973.170-88",
    "name": "Maria Luiza Pires",
    "email": "denna@wisozk.biz",
    "birth_date": "2001-03-11",
    "address": "165 Rua Rafaela",
    "city": "Ituverava",
    "state": "Alagoas",
    "crm": "B000BJ20J4",
    "crm_state": "PI",
    "id": "2",
    "patient_cpf": "048.973.170-88",
    "doctor_crm": "B000BJ20J4",
    "token": "IQCZ17",
    "exam_date": "2021-08-05",
    "exam_type": "leucócitos",
    "exam_limits": "9-61",
    "exam_result": "89"
  },
  ...
]
```
