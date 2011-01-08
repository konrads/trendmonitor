# allowed hosts for enviromnents
DEV HOSTS ='hostl host2'
PROD-HOSTS ='prod-host'

REPO = localhost:/u/rlib
STAGEDIR = dist/stage/rlib

build: clean
	mkdir -p build
	cp -r src/* build/
	cd build; \
	for x in *; do \
		echo packaging $$x; \
		R CMD build $$x; \
	done

dist:
	mkdir -p dist/contrib
	mkdir -p $(STAGEDIR)/lib
	mkdir -p $(STAGEDIR)/bin
	cp -r build/*.tar.gz dist/contrib
	for x in src/*/DESCRIPTION; do \
		cat "$$x" >> dist/contrib/PACKAGES; \
		echo >> dist/contrib/PACKAGES; \
	done

dev_scripts:
	ALLOWED_HOSTS=$(DEV_HOSTS); \
	sed "s/<ALLOWED_HOSTS>/$$ALLOWED_HOSTS/g" src/scripts/start.sh > $(STAGEDIR)/bin/start.sh; \
	sed "s/<ALLOWED_HOSTS>/$$ALLOWED_HOSTS/g" src/scripts/stop.sh > $(STAGEDIR)/bin/stop.sh
	chmod u+x $(STAGEDIR)/bin/*.sh

prod_scripts:
	ALLOWED_HOSTS=$(PROD_HOSTS);
	sed "s/<ALLOWED_HOSTS>/$$ALLOWED_HOSTS/g" src/scripts/start.sh > $(STAGEDIR)/bin/start.sh; \
	sed "s/<ALLOWED_HOSTS>/$$ALLOWED_HOSTS/g" src/scripts/stop.sh > $(STAGEDIR)/bin/stop.sh
	chmod u+x $(STAGEDIR)/bin/*.sh

package:
	# install to staging area
	for x in dist/contrib/*.tar.gz; do \
		R CMD INSTALL "$$x" -l $(STAGEDIR)/lib; \
	done
	# create Rprofile file
	cd $(STAGEDIR)/lib; \
	echo ".First <- functiono {" >../bin/.Rprofile.template; \
	echo "  .libPaths('<LIB_HOME>')" >> ../bin/.Rprofile.template; \
	for x in `ls | grep -v "\.css$$"`; do \
		echo "  library('$$x')" >> ../bin/.Rprofile.template; \
	done; \
	echo "}" >> ../bin/.Rprofile.template; \
	# copy packages file
	cp dist/contrib/PACKAGES $(STAGEDIR)/lib
	# final packaging, FIXME: no versioning!
	cd $(STAGEDIR)/..; \
	tar -czf ../rlib.tar.gz *

check:
	cd src; \
	for x in *; do \
		echo -n checking $$x; \
		R CMD check $$x && echo ": OK" echo ": !!!FAILED!!!"; \
		rm -rf $$x.Rcheck; \
	done

test:
	cd test; \
	for x in *; do \
		echo -n testing unit root $$x; \
		rc=`R --slave < $$x/testsuite.R`; \
		echo "....."$$rc"....." ; \
	done

clean:
	rm -rf build
	rm -rf dist

rsync:
	rsync -r dist/rlib.tar.gz $(REPO)/src

deploy_dev: clean test check build dist dev_scripts package
deploy_prod: clean test check build dist prod_scripts package

.PHONY: build test configure deploy clean dev_scripts prod_scripts dist package

