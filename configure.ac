dnl Autoconf configure script for search

dnl Process this file with autoconf to produce a configure script.

AC_INIT(src/search.ads)

# Current release settings
SEARCH_MAJOR_VERSION=0
SEARCH_MINOR_VERSION=1
SEARCH_MICRO_VERSION=0
SEARCH_VERSION=$SEARCH_MAJOR_VERSION.$SEARCH_MINOR_VERSION.$SEARCH_MICRO_VERSION

# Set the version number of the project
AC_SUBST(SEARCH_VERSION)
AC_SUBST(SEARCH_MAJOR_VERSION)
AC_SUBST(SEARCH_MINOR_VERSION)
AC_SUBST(SEARCH_MICRO_VERSION)

AM_GNAT_LIBRARY_PROJECT(search)

AM_GNAT_FIND_ADA_UTIL([search])

AM_GNAT_FIND_PROJECT([ada-steamer],[Ada Stemmer Library],[stemmer],
  [git@github.com:stcarrez/ada-stemmer.git],
  [Building Ada Search requires the Ada Stemmer Library.],
  [
    STEMMER_DIR=${ac_cv_gnat_project_dir_stemmer}
  ])
AC_SUBST(STEMMER_DIR)

AC_OUTPUT(
Makefile.conf
search.gpr
search_tests.gpr
)
