# @(#)51  1.1  src/ipfl/Makefile, ipflt, 53ipfl53H, 0619A_53ipfl53H 5/8/06 07:32:08
# IBM_PROLOG_BEGIN_TAG 
# This is an automatically generated prolog. 
#  
# 53ipfl53H src/ipfl/Makefile 1.1 
#  
# Licensed Materials - Property of IBM 
#  
# Restricted Materials of IBM 
#  
# (C) COPYRIGHT International Business Machines Corp. 2006 
# All Rights Reserved 
#  
# US Government Users Restricted Rights - Use, duplication or 
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp. 
#  
# IBM_PROLOG_END_TAG 
SUBDIRS = usr/lib usr/sbin usr/lib/methods kernext

all: kernext/sys/socketvar.h kernext/sys/ioctl.h
	touch kernext/sys/libsysp.h
	for i in $(SUBDIRS); do \
		(cd $$i && $(MAKE) $(MAKEFLAGS)); \
	done

bff:	all
	mkdir -p usr/lib/drivers
	cp kernext/ipf usr/lib/drivers/ipf
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

kernext/sys/ioctl.h: /usr/include/sys/ioctl.h
	mkdir -p kernext/sys
	sed "s#(0x40000000<<1)#(0x80000000)#" $^ | sed "s#((sizeof(t)\&IOCPARM_MASK)#(int)((sizeof(t)\&IOCPARM_MASK)#g" > $@