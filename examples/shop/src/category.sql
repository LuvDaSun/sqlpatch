-- @require product

CREATE TABLE category
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position INT NOT NULL
);

CREATE TABLE category_product
(
    category_id INT REFERENCES category,
    product_id INT REFERENCES product,
    product_position INT NOT NULL,
    PRIMARY KEY (category_id, product_id)
);
