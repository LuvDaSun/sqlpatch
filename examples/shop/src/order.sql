-- @require product

CREATE TABLE "order"
(
    id SERIAL PRIMARY KEY,
    address TEXT NOT NULL
);

CREATE TABLE order_product
(
    order_id INT NOT NULL REFERENCES "order",
    product_id INT NOT NULL REFERENCES product,
    quantity INT NOT NULL,
    price MONEY NOT NULL,
    PRIMARY KEY (order_id, product_id)
);
