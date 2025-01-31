-- https://www.geeksforgeeks.org/how-to-design-a-database-for-identity-management-systems/

DROP DATABASE IF EXISTS iam;
CREATE DATABASE IF NOT EXISTS iam;

CREATE USER IF NOT EXISTS roachie;

GRANT ALL PRIVILEGES ON DATABASE iam TO roachie;
GRANT SYSTEM EXTERNALIOIMPLICITACCESS TO roachie;

USE iam;

-- Authentication Provider Table
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS auth_provider;
DROP TABLE IF EXISTS iam_roles;
DROP TABLE IF EXISTS iam_users;      
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS role_permission;

-- Audit Log Table
CREATE TABLE IF NOT EXISTS audit_log (
    log_id        INT NOT NULL
  , user_id       INT
  , activity      TEXT
  , log_Timestamp TIMESTAMP
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO audit_log CSV DATA ('http://10.0.1.2:3000/audit_log.csv');

-- Authorization Provider table
CREATE TABLE auth_provider (
    provider_id   INT NOT NULL
  , provider_name VARCHAR(100)
  , provider_Type VARCHAR(150)
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO auth_provider CSV DATA ('http://10.0.1.2:3000/auth_provider.csv');
      
-- Role Table
CREATE TABLE IF NOT EXISTS iam_roles (
    role_id          INT NOT NULL
  , role_name        VARCHAR(100)
  , role_description TEXT
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO iam_roles CSV DATA ('http://10.0.1.2:3000/iam_roles.csv');

-- User Table
CREATE TABLE IF NOT EXISTS iam_users (
    user_id INT NOT NULL
  , user_name VARCHAR(100)
  , user_passwd VARCHAR(255)
  , email VARCHAR(255)
  , phone VARCHAR(20)
  , role_id INT
  , provider_id INT
 );

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO iam_users CSV DATA ('http://10.0.1.2:3000/iam_users.csv');

-- Permission Table
CREATE TABLE IF NOT EXISTS permissions (
    permission_id   INT NOT NULL
  , permission_name VARCHAR(100)
  , permission_desc TEXT
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO permissions CSV DATA ('http://10.0.1.2:3000/permissions.csv');

-- Junction Table for Role-Permission Relationship
CREATE TABLE IF NOT EXISTS role_permission (
   role_id       INT NOT NULL
 , permission_id INT
);

-- change the hostname and make sure the pyton http server is running from the directory where the data is.
IMPORT INTO role_permission CSV DATA ('http://10.0.1.2:3000/role_permissions.csv');

-- Create primary keys

ALTER TABLE ONLY audit_log
  ADD CONSTRAINT pk_log_id PRIMARY KEY (log_id);

ALTER TABLE ONLY auth_provider
  ADD CONSTRAINT pk_provider_id PRIMARY KEY (provider_id);

ALTER TABLE ONLY iam_roles
  ADD CONSTRAINT pk_role_id PRIMARY KEY (role_id);

ALTER TABLE ONLY iam_users
  ADD CONSTRAINT pk_user_id PRIMARY KEY (user_id);

ALTER TABLE ONLY permissions
  ADD CONSTRAINT pk_permission_id PRIMARY KEY (permission_id);

-- Create foreign key

ALTER TABLE ONLY iam_users 
  ADD CONSTRAINT fk_prov_usr FOREIGN KEY (provider_id) REFERENCES auth_provider;

ALTER TABLE ONLY iam_users 
  ADD CONSTRAINT fk_usr_role FOREIGN KEY (role_id) REFERENCES iam_roles;

ALTER TABLE ONLY audit_log  
  ADD CONSTRAINT fk_usr_audit FOREIGN KEY (user_id) REFERENCES iam_users;

ALTER TABLE ONLY role_permission     
  ADD CONSTRAINT fk_perm_role FOREIGN KEY (permission_id) references permissions  ;

ALTER TABLE ONLY role_permission     
  ADD CONSTRAINT fk_role_perm FOREIGN KEY (role_id) references iam_roles ;

