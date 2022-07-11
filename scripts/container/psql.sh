# Can access without password, only using in local develop
docker run --name psql -e POSTGRES_HOST_AUTH_METHOD=trust -p 5432:5432 -d postgres:alpine
