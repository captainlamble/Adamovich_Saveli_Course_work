CREATE SCHEMA IF NOT EXISTS oltp_fdw;

CREATE EXTENSION IF not exists postgres_fdw;

DROP SERVER IF EXISTS oltp_server CASCADE ;
CREATE SERVER oltp_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (
        host 'postgres-course-work',
        port '5432',
        dbname 'oltpcoursework',
        use_remote_estimate 'true',
        fetch_size '1000'
        );

CREATE USER MAPPING FOR current_user
    SERVER oltp_server
    OPTIONS (
        user 'username',
        password 'password'
        );

IMPORT FOREIGN SCHEMA oltp
    FROM SERVER oltp_server
    INTO oltp_fdw;