FROM postgres:15.3

LABEL author="safi"
LABEL description="Postgres Image for e-commerce business"
LABEL version="1.0"

COPY create.sql /docker-entrypoint-initdb.d/
