PRAGMA foreign_keys = ON;

CREATE TABLE Client (
    client_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    surname     VARCHAR NOT NULL,
    name        VARCHAR NOT NULL,
    patronymic  VARCHAR,
    gender      VARCHAR NOT NULL,
    birth_date  DATE NOT NULL,
    phone       VARCHAR NOT NULL UNIQUE,
    email       VARCHAR UNIQUE
);

CREATE TABLE Subscription (
    subscription_id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id       INTEGER NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    visit_limit     INTEGER,
    price           INTEGER NOT NULL,
    paid_at         TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES Client (client_id)
);

CREATE TABLE SportService (
    sport_service_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title            VARCHAR NOT NULL,
    location         VARCHAR NOT NULL,
    price            INTEGER NOT NULL
);

CREATE TABLE SubscriptionItem (
    subscription_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    subscription_id      INTEGER NOT NULL,
    sport_service_id      INTEGER NOT NULL,
    FOREIGN KEY (subscription_id) REFERENCES Subscription (subscription_id),
    FOREIGN KEY (sport_service_id) REFERENCES SportService (sport_service_id),
    UNIQUE (subscription_id, sport_service_id)
);

CREATE INDEX idx_subscription_client       ON Subscription (client_id);
CREATE INDEX idx_subscription_item_sub     ON SubscriptionItem (subscription_id);
CREATE INDEX idx_subscription_item_service ON SubscriptionItem (sport_service_id);