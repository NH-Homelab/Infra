\c nh_homelab

-- Users stored independent of their authentication credentials
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- For classic username/password login
CREATE TABLE user_credentials (
    user_id INT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    username TEXT UNIQUE NOT NULL,
    password_hash CHAR(60) NOT NULL,   -- bcrypt hashes are 60 chars
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- For Google OAuth login
CREATE TABLE user_google_oauth (
    user_id INT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    google_id TEXT UNIQUE NOT NULL, -- their Google account ID
    refresh_token TEXT,             -- nullable if you only need ID token
    created_at TIMESTAMP DEFAULT now()
);

--User Groups grant permissions to access nginx routes.
CREATE TABLE Groups (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

--Default groups
INSERT INTO groups (name) VALUES ('admin'), ('user'), ('unverified'), ('banned');

-- Map users to their groups
CREATE TABLE user_groups (
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  group_id INT REFERENCES groups(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, group_id)
);

-- Applications (the web apps/resources on your domain)
CREATE TABLE applications (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    subdomain TEXT
);

-- Group permissions (which groups can access which applications)
CREATE TABLE group_permissions (
    group_id INT REFERENCES groups(id) ON DELETE CASCADE,
    application_id INT REFERENCES applications(id) ON DELETE CASCADE,
    PRIMARY KEY (group_id, application_id)
);