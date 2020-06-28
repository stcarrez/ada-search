# Ada Search Library

[![License](https://img.shields.io/badge/license-APACHE2-blue.svg)](LICENSE)

Ada Search is a search engine written in Ada and heavily inspired from the Java
[Lucene](https://lucene.apache.org) search engine.

Ada Search uses the following libraries:

* Ada Util      (https://github.com/stcarrez/ada-util)
* Ada Stemmer   (https://github.com/stcarrez/ada-stemmer)
* ADO           (https://github.com/stcarrez/ada-ado)

# Status

This is a work in progress development.

* A simple white space tokenizer is provided,
* A set of token filters are available (lower case, natural language stemmer)

There is missing:

* an in-memory indexer,
* a database indexer,
* the query and search engine on top of the indexers.


# Build

Build with the following commands:
```
   ./configure
   make
```

The unit tests contains several reference files in `regtests/files` that come from the


# References

* [Lucene](https://lucene.apache.org) search engine.
