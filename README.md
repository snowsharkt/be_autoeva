# Auto Eva Backend

## Setup for Development:
- `docker compose build`
- `docker compose up`

## Setup for Production:

- `echo "DATABASE_PASSWORD=your_secure_password" > .env`
- `echo "SECRET_KEY_BASE=$(docker-compose exec web rails secret)" >> .env`

    ### Build and run
    - `docker compose -f docker-compose.prod.yml build`
    - `docker compose -f docker-compose.prod.yml up -d`
