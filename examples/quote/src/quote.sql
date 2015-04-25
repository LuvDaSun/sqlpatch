-- @require user_profile

CREATE TABLE quote
(
    id SERIAL PRIMARY KEY,
    text VARCHAR(100),
    owner INT REFERENCES profile
);
