.PHONY: rel

all: compile

compile:
	./rebar compile

clean:
	./rebar clean

distclean: clean relclean

eunit: 
	./rebar eunit

##
## Release targets
##
rel:
	./rebar compile generate 

relclean:
	rm -rf rel/trendmonitor
	rm -r logs

