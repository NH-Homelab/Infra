-- Create the authentication database
-- CREATE DATABASE authentication;

-- Connect to the authentication database
\c authentication

-- Create the Users table
CREATE TABLE Users (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(255) NOT NULL,
  lastname VARCHAR(255),
  email VARCHAR(320) NOT NULL,
  google_profile_id VARCHAR(21) NOT NULL
);

--User Groups grant permissions to access nginx routes.
CREATE TABLE Groups (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

-- Register applications temporarily running behind the reverse proxy
CREATE TABLE Applications (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  port INTEGER NOT NULL,
  host varchar(255) NOT NULL
);

-- Manage applications permissions by group
CREATE TABLE Applications_to_Groups (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL,
  group_id INTEGER NOT NULL,
  FOREIGN KEY (application_id) REFERENCES Applications (id),
  FOREIGN KEY (group_id) REFERENCES Groups (id)
);


CREATE TABLE Users_to_Groups (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  group_id INTEGER NOT NULL,
  UNIQUE (user_id, group_id),
  FOREIGN KEY (user_id) REFERENCES Users (id),
  FOREIGN KEY (group_id) REFERENCES Groups (id)
);

--Default groups
INSERT INTO Groups (name) VALUES ('admin'), ('user'), ('unverified'), ('banned');

CREATE VIEW userGroup AS
  SELECT A.id, 
        A.firstname, 
        A.lastname, 
        A.email, 
        A.google_profile_id, 
        array_agg(B.group_id) AS groups
  FROM Users AS A
  JOIN Users_to_Groups AS B ON A.id = B.user_id
  GROUP BY A.id;

--Prefix is the route that the group has access to. Null is the root node. previous allows different permissions for a "deeper" route. many to one group. Try not to overlap permission groups too much for efficiency.
CREATE TABLE Group_Permissions (
  id SERIAL PRIMARY KEY,
  group_id INTEGER NOT NULL,
  subdomain VARCHAR(255),
  prefix VARCHAR(255) NOT NULL,
  previous_prefix INTEGER NOT NULL,
  FOREIGN KEY (previous_prefix) REFERENCES Group_Permissions (id)
);