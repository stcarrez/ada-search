/* Copied from ado-postgresql.sql*/
/* File generated automatically by dynamo */
/* Entity table that enumerates all known database tables */
CREATE TABLE IF NOT EXISTS ado_entity_type (
  /* the database table unique entity index */
  "id" SERIAL,
  /* the database entity name */
  "name" VARCHAR(127) UNIQUE ,
  PRIMARY KEY ("id")
);
/* Sequence generator */
CREATE TABLE IF NOT EXISTS ado_sequence (
  /* the sequence name */
  "name" VARCHAR(127) UNIQUE NOT NULL,
  /* the sequence record version */
  "version" INTEGER NOT NULL,
  /* the sequence value */
  "value" BIGINT NOT NULL,
  /* the sequence block size */
  "block_size" BIGINT NOT NULL,
  PRIMARY KEY ("name")
);
/* Database schema version (per module) */
CREATE TABLE IF NOT EXISTS ado_version (
  /* the module name */
  "name" VARCHAR(127) UNIQUE NOT NULL,
  /* the database version schema for this module */
  "version" INTEGER NOT NULL,
  PRIMARY KEY ("name")
);
INSERT INTO ado_entity_type (name) VALUES
('ado_entity_type'), ('ado_sequence'), ('ado_version')
  ON CONFLICT DO NOTHING;
/* Copied from search-postgresql.sql*/
/* File generated automatically by dynamo */
/*  */
CREATE TABLE IF NOT EXISTS search_document (
  /* the document identifier. */
  "id" BIGINT NOT NULL,
  /*  */
  "index_id" BIGINT NOT NULL,
  PRIMARY KEY ("id")
);
/*  */
CREATE TABLE IF NOT EXISTS search_field (
  /* the field identifier. */
  "id" BIGINT NOT NULL,
  /* the field name. */
  "name" VARCHAR(255) NOT NULL,
  /* the field optional saved value. */
  "value" VARCHAR(255) NOT NULL,
  /* the field document. */
  "document_id" BIGINT NOT NULL,
  PRIMARY KEY ("id")
);
/*  */
CREATE TABLE IF NOT EXISTS search_index (
  /* the index identifier. */
  "id" BIGINT NOT NULL,
  PRIMARY KEY ("id")
);
/*  */
CREATE TABLE IF NOT EXISTS search_sequence (
  /*  */
  "positions" BYTEA NOT NULL,
  /* the token being referenced. */
  "token" BIGINT NOT NULL,
  /* the field being indexed. */
  "field" BIGINT NOT NULL,
  PRIMARY KEY ("token", "field")
);
/*  */
CREATE TABLE IF NOT EXISTS search_token (
  /* the token identifier */
  "id" BIGINT NOT NULL,
  /* the token string */
  "name" VARCHAR(255) NOT NULL,
  /*  */
  "index_id" BIGINT NOT NULL,
  PRIMARY KEY ("id")
);
INSERT INTO ado_entity_type (name) VALUES
('search_document'), ('search_field'), ('search_index'), ('search_sequence'), ('search_token')
  ON CONFLICT DO NOTHING;
INSERT INTO ado_version (name, version)
  VALUES ("search", 1)
  ON CONFLICT DO NOTHING;
