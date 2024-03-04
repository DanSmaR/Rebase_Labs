# Medical Exams API

This is a Ruby API that provides access to medical exams data. It uses Sinatra as the web framework and PostgreSQL as the database, all installed inside docker containers.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed the latest version of [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

## Running the API

To run the API, follow these steps:

1. Clone this repository.
2. Navigate to the project directory.
3. Run the following command:

```sh
docker compose up
```
This command will start two Docker containers: one for the PostgreSQL database and one for the Ruby/Sinastra API. The API will be available at `http://localhost:3000`.

Firstly, the database will be created and be connected. 
This message will be on the console for a while:

```sh
db-1   | 2024-03-04 17:02:25.373 UTC [36] LOG:  database system is ready to accept connections
```

After this, the database will be seeded with some data.

Then, the API will be started. In the console, you will see the API logs. You will be granted access to the API once you see this message:
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


## Accessing the Containers

To access the Ruby API container, run:

```sh
docker exec -it <container_id> bash
```

Replace `<container_id>` with the ID of the Ruby API container. You can get the container ID by running `docker ps`.

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
