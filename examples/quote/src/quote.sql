-- require src/profile.sql

CREATE TABLE quote
(
    id SERIAL PRIMARY KEY,
    text VARCHAR(100),
    owner INT REFERENCES profile
);
