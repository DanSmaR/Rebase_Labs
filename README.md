# Medical Exams App

This is a Ruby application that provides access to medical exams data. It uses Sinatra as the web framework and PostgreSQL as the database, all installed inside docker containers.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed the latest version of [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

## Running the Application

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

To run the Application, follow these steps:

1. Clone this repository.
2. Navigate to the project directory.
3. Run the following commands:

Change the permissions of bin/dev to make it executable
```sh
chmod +x bin/dev
```

To build, (re)create, start and attach to the application with Docker Compose (Recommended), because it's easier to see the logs and the containers are created in the correct order to function properly, run the following command:
```sh
bin/dev up
```

To stop containers and remove containers, networks, volumes, and images created by up:
```sh
bin/dev down
```

To start existing containers for a service:
```sh
bin/dev start
```

To stop existing containers for a service without removing them. hey can be started again with `bin/dev start`:
```sh
bin/dev stop
```

To rebuild the application with Docker Compose:
```sh
bin/dev rebuild
```

The command `bin/dev start` will start three (3) Docker containers: one for the PostgreSQL database, one for the Ruby/Sinastra API and one for the frontend Ruby/Sinastra App. The API will be available at `http://localhost:3001/tests` in your local machine. Inside the containers, the API will be available at `http://backend:3001/tests`.

Firstly, the database will be created and be connected. 
This message will be on the console for a while if you are using the `bin/dev start` command:

```sh
db-1   | 2024-03-04 17:02:25.373 UTC [36] LOG:  database system is ready to accept connections
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
app-1  | * Listening on http://0.0.0.0:3001
app-1  | Use Ctrl-C to stop
```

## Accessing the Frontend App

To access the frontend app, open your browser and navigate to `http://localhost:3000/` after this log appears in the console:

```sh
medical_exams_frontend  | wait-for-it.sh: backend:3001 is available after 2 seconds
medical_exams_frontend  | Puma starting in single mode...
medical_exams_frontend  | * Puma version: 6.4.2 (ruby 3.2.3-p157) ("The Eagle of Durango")
medical_exams_frontend  | *  Min threads: 0
medical_exams_frontend  | *  Max threads: 5
medical_exams_frontend  | *  Environment: development
medical_exams_frontend  | *          PID: 1
medical_exams_frontend  | * Listening on http://0.0.0.0:3000
medical_exams_frontend  | Use Ctrl-C to stop
```

## View containers information

To view the containers information, run:

```sh
docker ps
```

## Accessing the Containers

To access the API backend container, run:

```sh
docker exec -it medical_exams_backend bash
```

To access the App frontend container, run:

```sh
docker exec -it medical_exams_frontend bash
```

## Accessing the Database

To access the PostgreSQL database, run:

```sh
docker exec -it medical_exams_db psql -U postgres -d medical_exams
```

## View container logs

To view the logs of the containers, run:

```sh
docker logs <container_name>
```

if you started the containers with `bin/dev start`, you can use the following command to view the logs of the containers:

```sh
bin/dev logs
```

## Running the Tests

To run the tests, you need to access the specific containers as described above. Then, run:

```sh
cd src && bundle exec rspec
```

## Making Requests to the /tests Endpoint

You can make GET requests to the `/tests` endpoint to retrieve medical exams data. Here's an example using curl:

```sh
curl http://localhost:3001/tests
```

This will return a JSON array with the medical exams data.

```json
[
        {
          "token"=>"IQCZ17",
          "exam_date"=>"2021-08-05",
          "cpf"=>"048.973.170-88",
          "name"=>"Emilly Batista Neto",
          "email"=>"gerald.crona@ebert-quigley.com",
          "birthday"=>"2001-03-11",
          "address"=>"165 Rua Rafaela",
          "city"=>"Ituverava",
          "state"=>"Alagoas",
          "doctor"=>{
            "crm"=>"B000BJ20J4",
            "crm_state"=>"PI",
            "name"=>"Maria Luiza Pires",
            "email"=>"denna@wisozk.biz"
          },
          "tests"=>[
            {
              "type"=>"hemácias",
              "limits"=>"45-52",
              "result"=>"97"
            },
            {
              "type"=>"leucócitos",
              "limits"=>"9-61",
              "result"=>"89"
            },
            // rest of the tests
          ]
        },
        {
          "token"=>"0W9I67",
          "exam_date"=>"2021-07-09",
          "cpf"=>"048.108.026-04",
          "name"=>"Juliana dos Reis Filho",
          "email"=>"mariana_crist@kutch-torp.com",
          "birthday"=>"1995-07-03",
          "address"=>"527 Rodovia Júlio",
          "city"=>"Lagoa da Canoa",
          "state"=>"Paraíba",
          "doctor"=>{
            "crm"=>"B0002IQM66",
            "crm_state"=>"SC",
            "name"=>"Maria Helena Ramalho",
            "email"=>"rayford@kemmer-kunze.info"
          },
          "tests"=>[
            {
              "type"=>"hemácias",
              "limits"=>"45-52",
              "result"=>"28"
            },
            {
              "type"=>"leucócitos",
              "limits"=>"9-61",
              "result"=>"91"
            },
            // rest of the tests
          ]
        }
      ]
```

This endpoint also accepts a `token` named parameter to filter the exams by token. Here's an example:

```sh
curl http://localhost:3001/tests/IQCZ17
```

This will return a JSON object with the medical exam data for the token `IQCZ17`.

```json
[
  {
    "token"=>"IQCZ17",
    "exam_date"=>"2021-08-05",
    "cpf"=>"048.973.170-88",
    "name"=>"Emilly Batista Neto",
    "email"=>"gerald.crona@ebert-quigley.com",
    "birthday"=>"2001-03-11",
    "address"=>"165 Rua Rafaela",
    "city"=>"Ituverava",
    "state"=>"Alagoas",
    "doctor"=>{
      "crm"=>"B000BJ20J4",
      "crm_state"=>"PI",
      "name"=>"Maria Luiza Pires",
      "email"=>"denna@wisozk.biz"
    },
    "tests"=>[
      {
        "type"=>"hemácias",
        "limits"=>"45-52",
        "result"=>"97"
      },
      {
        "type"=>"leucócitos",
        "limits"=>"9-61",
        "result"=>"89"
      },
      // rest of the tests
    ]
  }
]
```
