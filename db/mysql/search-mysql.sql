/* File generated automatically by dynamo */
/*  */
CREATE TABLE IF NOT EXISTS search_document (
  /* the document identifier. */
  `id` BIGINT NOT NULL,
  /*  */
  `index_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*  */
CREATE TABLE IF NOT EXISTS search_field (
  /* the field identifier. */
  `id` BIGINT NOT NULL,
  /* the field name. */
  `name` VARCHAR(255) BINARY NOT NULL,
  /* the field optional saved value. */
  `value` VARCHAR(255) BINARY NOT NULL,
  /* the field document. */
  `document_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*  */
CREATE TABLE IF NOT EXISTS search_index (
  /* the index identifier. */
  `id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*  */
CREATE TABLE IF NOT EXISTS search_sequence (
  /*  */
  `positions` LONGBLOB NOT NULL,
  /* the token being referenced. */
  `token` BIGINT NOT NULL,
  /* the field being indexed. */
  `field` BIGINT NOT NULL,
  PRIMARY KEY (`token`, `field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*  */
CREATE TABLE IF NOT EXISTS search_token (
  /* the token identifier */
  `id` BIGINT NOT NULL,
  /* the token string */
  `name` VARCHAR(255) BINARY NOT NULL,
  /*  */
  `index_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT IGNORE INTO ado_entity_type (name) VALUES
("search_document"), ("search_field"), ("search_index"), ("search_sequence"), ("search_token");
INSERT IGNORE INTO ado_version (name, version) VALUES ("search", 1);
