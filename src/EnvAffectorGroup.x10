
/*
 * THINGS TO NOTE:
 * 
 * Environment affector groups are implemented as ArrayLists because
 * we don't know a priori how many affectors there will be. Many will
 * be created as the simulation progresses (ants dropping pheromones, etc.)
 * 
 * WHEN YOU DELETE an environment affector, make sure you remove all entries in all lists
 * (write a function for this), that have that index.
 * 
 */

import x10.util.ArrayList;
import x10.util.Random;
public abstract class EnvAffectorGroup {
    var size:Int;
    var pos:ArrayList[double];
    var group_type:Int;
    
    //seed with same number so we get same stream of numbers every time. We do this so we can get meaningful comparisons across multiple runs.
    static val rand = new Random(666);
    static val types = new EnvAffectorType();
    
    //env affectors implement this to model decay of strength, rotting, etc.
    public abstract def stepDynamicAttributes():void;
}

