DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'aydin'
   ) THEN
      CREATE USER aydin WITH PASSWORD 'sifre123';
   END IF;
END
$do$;

GRANT ALL PRIVILEGES ON DATABASE hotel_aydin TO aydin;
GRANT ALL PRIVILEGES ON SCHEMA public TO aydin;

