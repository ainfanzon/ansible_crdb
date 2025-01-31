-- DROP SCHEMA public;
DROP DATABASE IF EXISTS movr;
CREATE DATABASE IF NOT EXISTS movr;

CREATE USER IF NOT EXISTS roachie;

GRANT ALL PRIVILEGES ON DATABASE movr TO roachie;
GRANT SYSTEM EXTERNALIOIMPLICITACCESS TO roachie;

USE movr;

-- CREATE SCHEMA public AUTHORIZATION root;
-- public.promo_codes definition

-- Drop table

DROP TABLE IF EXISTS public.promo_codes;

CREATE TABLE IF NOT EXISTS public.promo_codes (
	code VARCHAR NOT NULL,
	description VARCHAR NULL,
	creation_time TIMESTAMP NULL,
	expiration_time TIMESTAMP NULL,
	rules JSONB NULL,
	CONSTRAINT promo_codes_pkey PRIMARY KEY (code ASC)
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO promo_codes CSV DATA ('http://10.0.1.2:3000/promo_codes.csv');

-- public."users" definition

-- Drop table

DROP TABLE IF EXISTS public."users";

CREATE TABLE IF NOT EXISTS public.users (
	id UUID NOT NULL,
	city VARCHAR NOT NULL,
	name VARCHAR NULL,
	address VARCHAR NULL,
	credit_card VARCHAR NULL,
	CONSTRAINT users_pkey PRIMARY KEY (city ASC, id ASC)
);
-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO users CSV DATA ('http://10.0.1.2:3000/users.csv');


-- public.user_promo_codes definition

-- Drop table

 DROP TABLE IF EXISTS public.user_promo_codes;

CREATE TABLE public.user_promo_codes (
	city VARCHAR NOT NULL,
	user_id UUID NOT NULL,
	code VARCHAR NOT NULL,
	"timestamp" TIMESTAMP NULL,
	usage_count INT8 NULL,
	CONSTRAINT user_promo_codes_pkey PRIMARY KEY (city ASC, user_id ASC, code ASC),
	CONSTRAINT user_promo_codes_city_user_id_fkey FOREIGN KEY (city, user_id) REFERENCES public.users(city, id)
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO user_promo_codes CSV DATA ('http://10.0.1.2:3000/user_promo_codes.csv');

-- public.vehicles definition

-- Drop table

DROP TABLE IF EXISTS public.vehicles;

CREATE TABLE IF NOT EXISTS public.vehicles (
	id UUID NOT NULL,
	city VARCHAR NOT NULL,
	type VARCHAR NULL,
	owner_id UUID NULL,
	creation_time TIMESTAMP NULL,
	status VARCHAR NULL,
	current_location VARCHAR NULL,
	ext JSONB NULL,
	CONSTRAINT vehicles_pkey PRIMARY KEY (city ASC, id ASC),
	CONSTRAINT vehicles_city_owner_id_fkey FOREIGN KEY (city, owner_id) REFERENCES public.users(city, id),
	INDEX vehicles_auto_index_fk_city_ref_users (city ASC, owner_id ASC)
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO vehicles CSV DATA ('http://10.0.1.2:3000/vehicles.csv');

-- public.rides definition

-- Drop table

DROP TABLE IF EXISTS public.rides;

CREATE TABLE IF NOT EXISTS public.rides (
	id UUID NOT NULL,
	city VARCHAR NOT NULL,
	vehicle_city VARCHAR NULL,
	rider_id UUID NULL,
	vehicle_id UUID NULL,
	start_address VARCHAR NULL,
	end_address VARCHAR NULL,
	start_time TIMESTAMP NULL,
	end_time TIMESTAMP NULL,
	revenue DECIMAL(10,2) NULL,
	CONSTRAINT rides_pkey PRIMARY KEY (city ASC, id ASC),
	CONSTRAINT rides_city_rider_id_fkey FOREIGN KEY (city, rider_id) REFERENCES public.users(city, id),
	CONSTRAINT rides_vehicle_city_vehicle_id_fkey FOREIGN KEY (vehicle_city, vehicle_id) REFERENCES public.vehicles(city, id),
	INDEX rides_auto_index_fk_city_ref_users (city ASC, rider_id ASC),
	INDEX rides_auto_index_fk_vehicle_city_ref_vehicles (vehicle_city ASC, vehicle_id ASC),
	CONSTRAINT check_vehicle_city_city CHECK (vehicle_city = city)
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO rides CSV DATA ('http://10.0.1.2:3000/rides.csv');

-- public.vehicle_location_histories definition

-- Drop table

DROP TABLE IF EXISTS public.vehicle_location_histories;

CREATE TABLE IF NOT EXISTS public.vehicle_location_histories (
	city VARCHAR NOT NULL,
	ride_id UUID NOT NULL,
	"timestamp" TIMESTAMP NOT NULL,
	lat FLOAT8 NULL,
	long FLOAT8 NULL,
	CONSTRAINT vehicle_location_histories_pkey PRIMARY KEY (city ASC, ride_id ASC, "timestamp" ASC),
	CONSTRAINT vehicle_location_histories_city_ride_id_fkey FOREIGN KEY (city, ride_id) REFERENCES public.rides(city, id)
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO vehicle_location_histories CSV DATA ('http://10.0.1.2:3000/vehicle_location_histories.csv');
