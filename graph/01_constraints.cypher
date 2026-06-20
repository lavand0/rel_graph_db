CREATE CONSTRAINT client_id_unique IF NOT EXISTS
FOR (c:Client) REQUIRE c.client_id IS UNIQUE;

CREATE CONSTRAINT client_phone_unique IF NOT EXISTS
FOR (c:Client) REQUIRE c.phone IS UNIQUE;

CREATE CONSTRAINT client_email_unique IF NOT EXISTS
FOR (c:Client) REQUIRE c.email IS UNIQUE;

CREATE CONSTRAINT client_surname_exists IF NOT EXISTS
FOR (c:Client) REQUIRE c.surname IS NOT NULL;

CREATE CONSTRAINT client_name_exists IF NOT EXISTS
FOR (c:Client) REQUIRE c.name IS NOT NULL;

CREATE CONSTRAINT client_gender_exists IF NOT EXISTS
FOR (c:Client) REQUIRE c.gender IS NOT NULL;

CREATE CONSTRAINT client_birth_date_exists IF NOT EXISTS
FOR (c:Client) REQUIRE c.birth_date IS NOT NULL;

CREATE CONSTRAINT client_phone_exists IF NOT EXISTS
FOR (c:Client) REQUIRE c.phone IS NOT NULL;

CREATE CONSTRAINT subscription_id_unique IF NOT EXISTS
FOR (s:Subscription) REQUIRE s.subscription_id IS UNIQUE;

CREATE CONSTRAINT subscription_start_date_exists IF NOT EXISTS
FOR (s:Subscription) REQUIRE s.start_date IS NOT NULL;

CREATE CONSTRAINT subscription_price_exists IF NOT EXISTS
FOR (s:Subscription) REQUIRE s.price IS NOT NULL;

CREATE CONSTRAINT sportservice_id_unique IF NOT EXISTS
FOR (ss:SportService) REQUIRE ss.sport_service_id IS UNIQUE;

CREATE CONSTRAINT sportservice_title_exists IF NOT EXISTS
FOR (ss:SportService) REQUIRE ss.title IS NOT NULL;

CREATE CONSTRAINT sportservice_location_exists IF NOT EXISTS
FOR (ss:SportService) REQUIRE ss.location IS NOT NULL;

CREATE CONSTRAINT sportservice_price_exists IF NOT EXISTS
FOR (ss:SportService) REQUIRE ss.price IS NOT NULL;
