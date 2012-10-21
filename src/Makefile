## DO NOT MODIFY THE CONTENTS OF THIS FILE

X10C=${X10_HOME}/bin/x10c++

FLAGS=-VERBOSE_CHECKS=TRUE -O -NO_CHECKS -noassert -cxx-prearg -O2
TARBALL=bioswarm_project.tar.gz

SRCS=BioSwarm.x10 FireflyGroup.x10 ActorGroup.x10 Scene.x10 AntGroup.x10 EnvAffectorGroup.x10 PheromoneGroup.x10 Box.x10

all: BioSwarm

BioSwarm: $(SRCS)
	$(X10C) $(FLAGS) -o BioSwarm $(SRCS)

clean:
	rm -f *.h *.cc BioSwarm *~
