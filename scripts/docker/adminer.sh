docker run --name adminer \
    -e ADMINER_DESIGN=nette \
    -e ADMINER_DRIVER=pgsql \
    -e ADMINER_PLUGINS="tables-filter" \
    -e ADMINER_SERVER=host.docker.internal \
    -e ADMINER_DB=postgres \
    -e ADMINER_USERNAME=*** \
    -e ADMINER_PASSWORD=*** \
    --stop-timeout 1 \
    -p 8080:8080 \
    -d \
    michalhosna/adminer

