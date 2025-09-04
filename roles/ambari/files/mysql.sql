-- Create Ambari user and grant privileges
CREATE USER 'ambari'@'localhost' IDENTIFIED BY 'ambari';
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'localhost';
CREATE USER 'ambari'@'%' IDENTIFIED BY 'ambari';
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'%';

-- Create required databases
CREATE DATABASE ambari CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE hive;
CREATE DATABASE ranger;
CREATE DATABASE rangerkms;

-- Create service users
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON hive.* TO 'hive'@'%';

CREATE USER 'ranger'@'%' IDENTIFIED BY 'ranger';
GRANT ALL PRIVILEGES ON *.* TO 'ranger'@'%' WITH GRANT OPTION;

CREATE USER 'rangerkms'@'%' IDENTIFIED BY 'rangerkms';
GRANT ALL PRIVILEGES ON rangerkms.* TO 'rangerkms'@'%';

FLUSH PRIVILEGES;