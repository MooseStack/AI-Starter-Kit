--## This script sets up the initial database schema for a PostgreSQL database.
--## I ran this manually the first time, then backed up the data and copied it into containerfile
--## Command executed for initial run of this script (enables pgvector and creates the table):
--## psql -h localhost -p 5432 -U postgres -d postgres -f postgres/initial-setup.sql 

-- This enables PGVector
CREATE EXTENSION vector;

-- This creates the documents table with the columns: id, content, metadata, and embedding
CREATE TABLE public.documents (
  id bigserial PRIMARY KEY,         -- Unique identifier
  content text,                     -- Textual content of the document
  metadata jsonb,                   -- Additional metadata (e.g., title, source)
  embedding vector                  -- Vector embeddings (for similarity search, etc.)
);

-- Create a function to search for documents
create function match_documents (
  query_embedding vector(512),
  match_count int DEFAULT null,
  filter jsonb DEFAULT '{}'
) returns table (
  id bigint,
  content text,
  metadata jsonb,
  embedding jsonb,
  similarity float
)
language plpgsql
as $$
#variable_conflict use_column
begin
  return query
  select
    id,
    content,
    metadata,
    (embedding::text)::jsonb as embedding,
    1 - (documents.embedding <=> query_embedding) as similarity
  from documents
  where metadata @> filter
  order by documents.embedding <=> query_embedding
  limit match_count;
end;
$$;