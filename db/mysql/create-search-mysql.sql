/* Copied from ado-mysql.sql*/
/* File generated automatically by dynamo */
/* Entity types */
CREATE TABLE entity_type (
  /* the entity type identifier */
  `id` INTEGER  AUTO_INCREMENT,
  /* the entity type name (table name) */
  `name` VARCHAR(127) UNIQUE NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/* Sequence generator */
CREATE TABLE sequence (
  /* the sequence name */
  `name` VARCHAR(127) NOT NULL,
  /* the sequence record version */
  `version` int ,
  /* the sequence value */
  `value` BIGINT ,
  /* the sequence block size */
  `block_size` BIGINT ,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;;
INSERT INTO entity_type (name) VALUES
("entity_type")
,("sequence")
;
/* Copied from search-mysql.sql*/
/* File generated automatically by dynamo */
/*  */
CREATE TABLE search_document (
  /* the document identifier. */
  `id` BIGINT NOT NULL,
  /*  */
  `index_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*  */
CREATE TABLE search_field (
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
CREATE TABLE search_index (
  /* the index identifier. */
  `id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*  */
CREATE TABLE search_sequence (
  /*  */
  `positions` LONGBLOB NOT NULL,
  /* the token being referenced. */
  `token` BIGINT NOT NULL,
  /* the field being indexed. */
  `field` BIGINT NOT NULL,
  PRIMARY KEY (`token`, `field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*  */
CREATE TABLE search_token (
  /* the token identifier */
  `id` BIGINT NOT NULL,
  /* the token string */
  `name` VARCHAR(255) BINARY NOT NULL,
  /*  */
  `index_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO entity_type (name) VALUES
("search_document")
,("search_field")
,("search_index")
,("search_sequence")
,("search_token")
;
