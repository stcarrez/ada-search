pragma synchronous=OFF;
/* Copied from ado-sqlite.sql*/
/* File generated automatically by dynamo */
/* Entity table that enumerates all known database tables */
CREATE TABLE IF NOT EXISTS ado_entity_type (
  /* the database table unique entity index */
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
  /* the database entity name */
  `name` VARCHAR(127) UNIQUE );
/* Sequence generator */
CREATE TABLE IF NOT EXISTS ado_sequence (
  /* the sequence name */
  `name` VARCHAR(127) UNIQUE NOT NULL,
  /* the sequence record version */
  `version` INTEGER NOT NULL,
  /* the sequence value */
  `value` BIGINT NOT NULL,
  /* the sequence block size */
  `block_size` BIGINT NOT NULL,
  PRIMARY KEY (`name`)
);
/* Database schema version (per module) */
CREATE TABLE IF NOT EXISTS ado_version (
  /* the module name */
  `name` VARCHAR(127) UNIQUE NOT NULL,
  /* the database version schema for this module */
  `version` INTEGER NOT NULL,
  PRIMARY KEY (`name`)
);
INSERT OR IGNORE INTO ado_entity_type (name) VALUES ("ado_entity_type");
INSERT OR IGNORE INTO ado_entity_type (name) VALUES ("ado_sequence");
INSERT OR IGNORE INTO ado_entity_type (name) VALUES ("ado_version");
/* Copied from search-sqlite.sql*/
/* File generated automatically by dynamo */
/*  */
CREATE TABLE IF NOT EXISTS search_document (
  /* the document identifier. */
  `id` BIGINT NOT NULL,
  /*  */
  `index_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
);
/*  */
CREATE TABLE IF NOT EXISTS search_field (
  /* the field identifier. */
  `id` BIGINT NOT NULL,
  /* the field name. */
  `name` VARCHAR(255) NOT NULL,
  /* the field optional saved value. */
  `value` VARCHAR(255) NOT NULL,
  /* the field document. */
  `document_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
);
/*  */
CREATE TABLE IF NOT EXISTS search_index (
  /* the index identifier. */
  `id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
);
/*  */
CREATE TABLE IF NOT EXISTS search_sequence (
  /*  */
  `positions` LONGBLOB NOT NULL,
  /* the token being referenced. */
  `token` BIGINT NOT NULL,
  /* the field being indexed. */
  `field` BIGINT NOT NULL,
  PRIMARY KEY (`token`, `field`)
);
/*  */
CREATE TABLE IF NOT EXISTS search_token (
  /* the token identifier */
  `id` BIGINT NOT NULL,
  /* the token string */
  `name` VARCHAR(255) NOT NULL,
  /*  */
  `index_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
);
INSERT OR IGNORE INTO ado_entity_type (name) VALUES ("search_document");
INSERT OR IGNORE INTO ado_entity_type (name) VALUES ("search_field");
INSERT OR IGNORE INTO ado_entity_type (name) VALUES ("search_index");
INSERT OR IGNORE INTO ado_entity_type (name) VALUES ("search_sequence");
INSERT OR IGNORE INTO ado_entity_type (name) VALUES ("search_token");
INSERT OR IGNORE INTO ado_version (name, version) VALUES ("search", 1);
