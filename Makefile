SUBDIRS = usr/lib usr/sbin usr/lib/methods kernext

all: kernext/sys/socketvar.h
	touch kernext/sys/libsysp.h
	for i in $(SUBDIRS); do \
		(cd $$i && $(MAKE) $(MAKEFLAGS)); \
	done
clean:
	rm -f kernext/sys/socketvar.h
	for i in $(SUBDIRS); do \
		(cd $$i && $(MAKE) $(MAKEFLAGS) clean); \
	done
kernext/sys/socketvar.h: /usr/include/sys/socketvar.h
	mkdir -p kernext/sys
	sed "s#free_sock_hash_table\[\]#*free_sock_hash_table#g" $^ > $@
