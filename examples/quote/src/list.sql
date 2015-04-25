-- @require user_profile
-- @require quote

CREATE TABLE list
(
    owner INT REFERENCES profile,
    quote INT REFERENCES quote,
    position INT NOT NULL,
    PRIMARY KEY(owner, quote)
);
