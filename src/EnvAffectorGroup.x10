
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


public abstract class EnvAffectorGroup {
    var size:Int;
    var pos:ArrayList[Double];
    
}