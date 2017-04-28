CREATE UNLOGGED TABLE sharedbuffers_usage (
    pk        serial PRIMARY KEY,
    time        timestamp with time zone NOT NULL,
    buffersize  integer NOT NULL

);



