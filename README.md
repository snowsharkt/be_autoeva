# Auto Eva Backend

## API docs

- Swagger: `http://localhost:3000/api-docs`

## Setup for Development:
- Create `.env` file from `.env.example` and set the environment variables
- `docker compose build`
- `docker compose up`

## Setup for Production:

- `echo "DATABASE_PASSWORD=your_secure_password" > .env`
- `echo "SECRET_KEY_BASE=$(docker-compose exec web rails secret)" >> .env`

    ### Build and run
    - `docker compose -f docker-compose.prod.yml build`
    - `docker compose -f docker-compose.prod.yml up -d`

## Data Import
The application comes with pre-defined car brands, models, and versions data that can be loaded using rake tasks:

- Import brands only: `rails import:brands`
- Import models only: `rails import:models`
- Import versions only: `rails import:versions`
- - Import versions only: `rails import:car_info`
- Import all data (in correct order): `rails import:all`

These tasks can be run after database setup to populate initial vehicle data.
