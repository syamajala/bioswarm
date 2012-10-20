X10C=${X10_HOME}/bin/x10c++
FLAGS=-VERBOSE_CHECKS=TRUE -O -NO_CHECKS -noassert -cxx-prearg -O2
SRCS=BioSwarm.x10 FireflyGroup.x10 ActorGroup.x10
TARBALL=bioswarm_project.tar.gz

EXES=BioSwarm

all: $(EXES)

.SUFFIXES:
.SUFFIXES: .x10

BioSwarm: $(SRCS)

.x10:
	$(X10C) $(FLAGS) -o $@ $@.x10

ship: $(TARBALL)

$(TARBALL): $(SHIP)
	tar cvfz $(TARBALL) $(TURNIN)

clean:
	rm -f $(EXES) *.h *.cc $(TARBALL)
