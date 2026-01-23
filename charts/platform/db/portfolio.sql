CREATE DATABASE portfolio;

\c portfolio

-- Projects have many milestones related to them
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Major project milestones show on the combined timeline; minor milestones only show up when viewing a project.
CREATE TYPE milestone_types AS ENUM ('education', 'project_major', 'project_minor', 'career');

-- Milestones are events that show up on the timeline
CREATE TABLE milestones (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    milestone_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description TEXT NOT NULL,
    body_url TEXT,      -- URL to markdown file
    github_url TEXT,    -- URL to github repo
    image_url TEXT,     -- URL to image file
    milestone_type milestone_types NOT NULL,
    status TEXT DEFAULT 'published' CHECK (status IN ('draft', 'published', 'archived')),
    project_id INT REFERENCES projects(id) ON DELETE CASCADE
);

-- Tags are short phrases that describe the milestone
CREATE TABLE milestone_tags (
    id SERIAL PRIMARY KEY,
    tag TEXT UNIQUE NOT NULL
);

-- Links tags to their milestones
CREATE TABLE tags_to_milestones (
    milestone INT NOT NULL REFERENCES milestones(id) ON DELETE CASCADE,
    tag INT NOT NULL REFERENCES milestone_tags(id) ON DELETE CASCADE,
    CONSTRAINT tags_to_milestones_pk PRIMARY KEY (milestone, tag)
);