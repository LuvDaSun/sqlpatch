-- require src/profile.sql
-- require src/quote.sql

CREATE TABLE list
(
    owner INT REFERENCES profile,
    quote INT REFERENCES quote,
    position INT NOT NULL,
    PRIMARY KEY(owner, quote)
);
