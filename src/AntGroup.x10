import x10.util.ArrayList;
import x10.util.Pair;

//ants move only within a 2d plane (ground), so we tend to ignore the third axis here.
public class AntGroup extends ActorGroup {
    //these ids tell us where to access certain environment affector groups.
    var ant_home_trail_pheromone_id:int;
    var ant_food_trail_pheromone_id:int;
    var food_affector_id:int;
    
    // how far, maximum, an ant can move in one time-step.
    val step_distance:double = 3.0;
    
    // max distance an ant will travel before deciding to go back to hive.
    val max_distance:double = 120.0;
    var distance_travelled:double = 0.0;
    
    // how much food it will take in a bite.
    val chomp_size = 2.0;
    
    val phero_strength = 10.0;
    
    // food calculation variables.
    var located_food:Array[boolean];
    var returning:Array[boolean];
    var target_pos:Array[double];
    
    // tells us how far away does an environment affector have to be to be sensed by ant.
    var search_radius:double = 25.0;
    // tells us which way ant is moving.
    var dir:Array[double];
    
    // every ant knows the hive location at the origin.
    val hive_pos = [0.0, 0.0, 0.0];
    
    // normally want ants starting from a single hive position at the origin
    def this(n:Int, scene:Scene) {
        this.size = n;
        this.pos = new Array[double](3*size, (p:Int) => 0.0);
        this.dir = new Array[double](3*size, (p:int) => 0.0);
        this.health = new Array[double](size, (p:Int) => 100.0);
        this.located_food = new Array[boolean](size, (p:Int) => false);
        this.returning = new Array[boolean](size, (p:Int) => true);
        this.target_pos = new Array[double](3*size, (p:int) => 0.0);
        
        this.scene = scene;
        
        this.initEnvAffectorIds();
    }

    
    def this(n:Int, pos:Array[Double], scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => pos(p));
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.dir = new Array[double](3*size, (p:int) => 0.0);
        this.health = new Array[double](size, (p:Int) => 100.0);
        this.located_food = new Array[boolean](size, (p:Int) => false);
        this.returning = new Array[boolean](size, (p:Int) => true);
        this.target_pos = new Array[double](3*size, (p:int) => 0.0);

        this.scene = scene;
        
        this.initEnvAffectorIds();
    }
    
    
    private def initEnvAffectorIds() {
        //Console.OUT.println("SIZE OF ALL ENV AFFECTORS:" + scene.affectorGroups.size);
        for (var i:Int = 0; i < scene.affectorGroups.size; i++) {
            //Console.OUT.println("group type: " + scene.affectorGroups(i).group_type);
            //Console.OUT.println("antFoodTrailPheromoneType: " + EnvAffectorType.antFoodTrailPheromone);
            if (scene.affectorGroups(i).group_type == EnvAffectorType.antFoodTrailPheromone) {
                this.ant_food_trail_pheromone_id = i;
                //Console.OUT.println("food trail phero id: " + this.ant_food_trail_pheromone_id + ", " + i);
            }
            else if (scene.affectorGroups(i).group_type == EnvAffectorType.Food)
                this.food_affector_id = i;
        }
    }

    public def stepActors():void {
        for (var i:Int = 0; i < this.size; i++) {

            //don't step it if it's dead.
            if (!this.alive(i))
                continue;

            var env:ArrayList[Pair[Int,Int]] = this.scene.envAffectorQuery(this.pos(3*i), this.pos(3*i+1), 0.0, this.search_radius);
            
            // are we at the hive?
            var at_hive:boolean = false;
            
            for (var p:int = 0; p < env.size(); p++) {
                if (env(p).first == EnvAffectorType.antHiveEntrance) {
                    at_hive = true;
                }
            }
            
            //check for target environment affectors and set appropriate target for the actor.
            var min_strength:double = Double.POSITIVE_INFINITY;
            for (var p:int = 0; p < env.size(); p++) {
                // food is first priority affector
                if (env(p).first == EnvAffectorType.Food) {
                    this.located_food(i) = true;
                    target_pos(3*i) = this.scene.affectorGroups(this.food_affector_id).pos(3*env(p).second);
                    target_pos(3*i+1) = this.scene.affectorGroups(this.food_affector_id).pos(3*env(p).second+1);
                    target_pos(3*i+2) = 0.0;
                    
                } else if (env(p).first == EnvAffectorType.antFoodTrailPheromone) { //go down the decreasing gradient of pheromone strength.
                    val food_trail_phero:PheromoneGroup = this.scene.affectorGroups(this.ant_food_trail_pheromone_id) as PheromoneGroup;
                    val test_min:double = food_trail_phero.strength(env(p).second);
                    
                    if ( test_min < min_strength && test_min > 1e-6) {
                        min_strength = test_min;
                        
	                    target_pos(3*i) = this.scene.affectorGroups(this.ant_food_trail_pheromone_id).pos(3*env(p).second);
	                    target_pos(3*i) = this.scene.affectorGroups(this.ant_food_trail_pheromone_id).pos(3*env(p).second+1);
	                    target_pos(3*i+2) = 0.0;
                    }
                    
                    this.located_food(i) = true;
                } // else if (env(p).first == EnvAffectorType.antHomeTrailPheromone) {
                //     
                // }
            }
            
            //move out in a random direction, with some variance.
            
            if (located_food(i) && returning(i)) { //race home and drop food found pheros along the way
                this.target_pos(3*i) = this.hive_pos(0);
                this.target_pos(3*i+1) = this.hive_pos(1);
                this.target_pos(3*i+2) = this.hive_pos(2);
                
                val dir_to_home:Array[double] = stepVectorToTarget(i);
                
                //drop the phero into environment.
                val food_trail_phero:PheromoneGroup = this.scene.affectorGroups(this.ant_food_trail_pheromone_id) as PheromoneGroup;
                
                food_trail_phero.pos.add(this.pos(3*i));
                food_trail_phero.pos.add(this.pos(3*i+1));
                food_trail_phero.pos.add(this.pos(3*i+2));
                food_trail_phero.strength.add(this.phero_strength);
                food_trail_phero.size++;
                
                this.pos(3*i) += dir_to_home(0);
                this.pos(3*i+1) += dir_to_home(1);
                this.pos(3*i+2) += dir_to_home(2);
                
            }
            else if (located_food(i) && !returning(i)) { //haven't gotten food yet, but found it.
                // move towards food if not far enough to get a bite. (can take bite within step_distance of food position).
                val dir_to_food:Array[double] = stepVectorToTarget(i);
                
                this.pos(3*i) += dir_to_food(0);
                this.pos(3*i+1) += dir_to_food(1);
                this.pos(3*i+2) += dir_to_food(2);
                
                if (distToTarget(i) < this.step_distance) { //reached food, eat some and set return flag.
                    val food:FoodGroup = this.scene.affectorGroups(this.food_affector_id) as FoodGroup;
                    if (food.available(0)) {
                    	food.quantity(0) -= this.chomp_size; //only using one food source in scene for now.
                    }
                    returning(i) = true;
                }
                
            } else if (returning(i) && at_hive) {
                //Console.OUT.println("ANT IS AT THE HIVE!");
                val range_mod:double = this.step_distance/2;
                
                //bestow a "main direction of travel" to this ant.
                dir(3*i) = rand.nextDouble()*this.step_distance - range_mod;
                dir(3*i+1) = rand.nextDouble()*this.step_distance - range_mod;
                dir(3*i+2) = 0.0;
                
                this.pos(3*i) += dir(3*i);
                this.pos(3*i+1) += dir(3*i+1);
                this.pos(3*i+2) += dir(3*i+2);
                
                returning(i) = false;
                located_food(i) = false;
                distance_travelled = 0.0;
                //Console.OUT.println(dir);
                
            } else if (returning(i)) { //just returning, nothing found but max dist was reached.
                this.target_pos(3*i) = this.hive_pos(0);
                this.target_pos(3*i+1) = this.hive_pos(1);
                this.target_pos(3*i+2) = this.hive_pos(2);
                
                val dir_to_home:Array[double] = stepVectorToTarget(i);
                
                this.pos(3*i) += dir_to_home(0);
                this.pos(3*i+1) += dir_to_home(1);
                this.pos(3*i+2) += dir_to_home(2);
                
            } else { //perturb by small factor, but mainly stay along original direction of travel.
                val factor:double = 1/10.0;
                val factor_mod:double = (this.step_distance*factor)/2;
                dir(3*i) += rand.nextDouble()*this.step_distance*factor - factor_mod;
                dir(3*i+1) += rand.nextDouble()*this.step_distance*factor - factor_mod;
                dir(3*i+2) = 0.0;
                
                //Console.OUT.println(dir);
                this.pos(3*i) += dir(3*i);
                this.pos(3*i+1) += dir(3*i+1);
                this.pos(3*i+2) += dir(3*i+2);
                
                distance_travelled += Math.sqrt( Math.pow(dir(3*i), 2) + Math.pow(dir(3*i+1), 2) + Math.pow(dir(3*i+2), 2) );
                if (distance_travelled > max_distance) { //we have travelled too far without finding anything, set flag to return to hive.
                    returning(i) = true;
                }
            }
            
            
            
        }
    }
    
    def stepVectorToTarget(actor_index:int) {
        val to_target = new Array[double](3);
        to_target(0) = this.target_pos(3*actor_index) - this.pos(3*actor_index);
        to_target(1) = this.target_pos(3*actor_index+1) - this.pos(3*actor_index+1);
        to_target(2) = this.target_pos(3*actor_index+2) - this.pos(3*actor_index+2);
        val distance = Math.sqrt(Math.pow(to_target(0), 2) + Math.pow(to_target(1), 2) + Math.pow(to_target(2), 2));
        
        val step_vector = new Array[double](3);
        step_vector(0) = (to_target(0) / distance) * this.step_distance;
        step_vector(1) = (to_target(1) / distance) * this.step_distance;
        step_vector(2) = (to_target(2) / distance) * this.step_distance;
        return step_vector;
    }
    
    def distToTarget(actor_index:int) {
        val to_target = new Array[double](3);
        to_target(0) = this.target_pos(3*actor_index) - this.pos(3*actor_index);
        to_target(1) = this.target_pos(3*actor_index+1) - this.pos(3*actor_index+1);
        to_target(2) = this.target_pos(3*actor_index+2) - this.pos(3*actor_index+2);
        return Math.sqrt(Math.pow(to_target(0), 2) + Math.pow(to_target(1), 2) + Math.pow(to_target(2), 2));
    }



    // def envFind(i:Int, env:ArrayList[Pair[Int,Int]]):Boolean {
    //     var j:Pair[Int, Int];
    //     for (var x:Int = 0; x < env.size(); x++) {
    //         j = env(x);
    //         if(j.first == i)
    //             return true;
    //     }
    //     return false;
    // }
    
}
