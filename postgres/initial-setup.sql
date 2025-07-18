--## This script sets up the initial database schema for a PostgreSQL database.
--## I ran this manually the first time, then backed up the data and copied it into containerfile
--## Command executed for initial run of this script (enables pgvector and creates the table):
--## psql -h localhost -p 5432 -U postgres -d postgres -f postgres/initial-setup.sql 

CREATE EXTENSION vector;

CREATE TABLE public.documents (
  id bigserial PRIMARY KEY,         -- Unique identifier
  content text,                     -- Textual content of the document
  metadata jsonb,                   -- Additional metadata (e.g., title, source)
  embedding vector                  -- Vector embeddings (for similarity search, etc.)
);