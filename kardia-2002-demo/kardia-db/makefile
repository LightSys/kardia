# vim: set ts=4 : #

#DIRS := partner somethingelse
#SCRIPTS := ${wildcard ${patsubst %,%/*.sql,${DIRS}}}
SCRIPTS := ${wildcard */*.sql}
DATASCRIPTS := ${wildcard */data/*.sql}
#DBUPS := ${patsubst %.sql,%.dbup,${SCRIPTS}}
SQLPROG = echo 

.PHONY: all clean depend cleanall dep

#commenting out the following line will cause the build.pl script to only run
#  if one of the SQL queries has changed, but there is the chance that 
#  build.pl was run with only some files on the last run, not all..
#  the script can handle that itself, but not if it's not run....
.PHONY: .buildtime

all: .buildtime

.buildtime: .depend ${SCRIPTS} ${DATASCRIPTS}
	./build.pl ${SCRIPTS} ${DATASCRIPTS}

clean: 
	rm -f .buildtime .depend

dep depend:
	./makedep.pl ${SCRIPTS} ${DATASCRIPTS} > .depend

.depend: makedep.pl ${SCRIPTS}
	./makedep.pl ${SCRIPTS} ${DATASCRIPTS} > .depend


#%.dbup : %.sql
#	#${SQLPROG} $<
#	#touch $@
#	./build.pl $@

#include .depend
