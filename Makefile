SUBDIRS = usr/lib usr/sbin usr/lib/methods kernext

all: kernext/sys/socketvar.h
	touch kernext/sys/libsysp.h
	for i in $(SUBDIRS); do \
		(cd $$i && $(MAKE) $(MAKEFLAGS)); \
	done

bff:	all
	mkdir -p usr/lib/drivers
	cp kernext/ipf usr/lib/drivers/
	rm -rf .info
	sed "s#<scriptdir>#`pwd`#g" ipfilter.tmpl >ipfilter.t
	mkinstallp -d . -T ipfilter.t

clean:
	rm -f kernext/sys/socketvar.h
	for i in $(SUBDIRS); do \
		(cd $$i && $(MAKE) $(MAKEFLAGS) clean); \
	done
	rm -f usr/lib/drivers/ipf
	rmdir usr/lib/drivers || true
	rm -f ipfilter.t
	rm -rf .info

kernext/sys/socketvar.h: /usr/include/sys/socketvar.h
	mkdir -p kernext/sys
	sed "s#free_sock_hash_table\[\]#*free_sock_hash_table#g" $^ > $@
