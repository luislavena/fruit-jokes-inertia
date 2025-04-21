# Fruit Jokes

A demo web application built with Crystal and Inertia.js for managing comedians
and their fruit-themed jokes.

## Requirements

- Docker
- Docker Compose
- Make

## Getting Started

### Build the project

Initialize the project by building the container and installing dependencies:

```bash
make setup
```

### Start the application

Start the dev services by running:

```bash
make dev
```

After a few seconds of the compilation of the Crystal application, it should be
available at http://localhost:8080

### Seed the database

Database is automatically created and migrated on startup of the application,
but it will be empty. You can seed the database with some sample data by running
the seeder in a new terminal:

```bash
make console
```

Then, populate the database:

```bash
shards run seed
```

### Play around

Now that you have some sample data, click around to explore the functionality.

## Available commands

The following commands are available using the `make`:

- `make setup` - Initialize the project (build container and install dependencies)
- `make dev` - Run the application services
- `make console` - Start an interactive console session
- `make restart` - Restart the containers
- `make stop` - Stop running containers
- `make help` - Show available tasks and usage examples

## License

Licensed under the Apache License, Version 2.0. You may obtain a copy of
the license [here](./LICENSE).
