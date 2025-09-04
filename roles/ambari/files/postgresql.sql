-- Create Ambari user and database
CREATE ROLE "ambari" LOGIN PASSWORD 'admin' NOINHERIT;
CREATE DATABASE ambari;
GRANT ALL PRIVILEGES ON DATABASE ambari TO ambari;

-- Create Hive user and database
CREATE ROLE "hive" LOGIN PASSWORD 'hive' NOINHERIT;
CREATE DATABASE hive;
GRANT ALL PRIVILEGES ON DATABASE hive TO hive;

-- Create Ranger user and database
CREATE ROLE "ranger" LOGIN PASSWORD 'ranger' NOINHERIT;
CREATE DATABASE ranger;
GRANT ALL PRIVILEGES ON DATABASE ranger TO ranger;

-- Create Ranger KMS user and database
CREATE ROLE "rangerkms" LOGIN PASSWORD 'rangerkms' NOINHERIT;
CREATE DATABASE rangerkms;
GRANT ALL PRIVILEGES ON DATABASE rangerkms TO rangerkms;
