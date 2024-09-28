NAME=search
VERSION=0.1.0

DIST_DIR=ada-search-$(VERSION)
DIST_FILE=ada-search-$(VERSION).tar.gz

MAKE_ARGS += -XSEARCH_BUILD=$(BUILD)

-include Makefile.conf

STATIC_MAKE_ARGS = $(MAKE_ARGS) -XSEARCH_LIBRARY_TYPE=static
SHARED_MAKE_ARGS = $(MAKE_ARGS) -XSEARCH_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XUTILADA_BASE_BUILD=relocatable -XUTIL_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XXMLADA_BUILD=relocatable
SHARED_MAKE_ARGS += -XLIBRARY_TYPE=relocatable

include Makefile.defaults

DYNAMO_ARGS=--package Search.Models \
  db uml/search.zargo

# Build executables for all mains defined by the project.
build-test::	lib-setup
	cd regtests && $(BUILD_COMMAND) $(GPRFLAGS) $(MAKE_ARGS)

# Build and run the unit tests
test:	build
	bin/search_harness -xml search-aunit.xml

generate:
	$(DYNAMO) generate $(DYNAMO_ARGS)

samples: search.db
	$(GNATMAKE) $(GPRFLAGS) -p -Psamples $(MAKE_ARGS)

search.db:
	sqlite3 search.db < db/sqlite/create-search-sqlite.sql

install-samples:
	$(MKDIR) -p $(samplesdir)/samples
	cp -rp $(srcdir)/samples/*.ad[sb] $(samplesdir)/samples/
	cp -p $(srcdir)/samples.gpr $(samplesdir)
	cp -p $(srcdir)/config.gpr $(samplesdir)

$(eval $(call ada_library,$(NAME),.))

.PHONY: samples
