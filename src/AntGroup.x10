import x10.util.ArrayList;
import x10.util.Pair;

public class AntGroup extends ActorGroup {
    var ant_home_trail_pheromone_id:int;
    var ant_food_trail_pheromone_id:int;
    var food_affector_id:int;
    val step_distance:double = 5.0;
    
    var search_radius:Array[double];
    
    
    // normally want ants starting from a single hive position at the origin
    def this(n:Int, scene:Scene) {
        this.size = n;
        this.pos = new Array[double](3*size, (p:Int) => 0.0);
        this.health = new Array[double](size, (p:Int) => 100.0);
        this.search_radius = new Array[double](size, (p:Int) => rand.nextDouble()*5.0 + 20.0);
        //this.digestion_rate = new Array[Double](size, (p:Int) => 0.0);
        //this.on_affector = new Array[Boolean](size, (p:Int) => false);
        this.scene = scene;
        
        this.initEnvAffectorIds();
    }

    // normally don't want ants starting out from an area.
    def this(n:Int, r:Box, scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size);
        for (var i:Int = 0; i < size; i++) {

            var x:Double = rand.nextInt(r.l as Int) as Double + r.v1(0);
            var y:Double = rand.nextInt(r.w as Int) as Double + r.v1(1);
            var z:Double = 0;

            this.pos(3*i) = x;
            this.pos(3*i+1) = y;
            this.pos(3*i+2) = z;
        }

        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.search_radius = new Array[double](size, (p:Int) => rand.nextDouble()*5.0 + 20.0);
        //this.digestion_rate = new Array[Double](size, (p:Int) => 0.0);
        //this.on_affector = new Array[Boolean](size, (p:Int) => false);
        this.scene = scene;
        
        this.initEnvAffectorIds();
    }

    
    def this(n:Int, pos:Array[Double], scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => pos(p));
        this.health = new Array[Double](size, (p:Int) => 100.0);
        //this.digestion_rate = new Array[Double](size, (p:Int) => 0.0);
        //this.on_affector = new Array[Boolean](size, (p:Int) => false);

        this.scene = scene;
        
        this.initEnvAffectorIds();
    }
    
    
    private def initEnvAffectorIds() {
        for (var i:Int = 0; i < scene.affectorGroups.size; i++) {
            if (scene.affectorGroups(i).group_type == EnvAffectorType.antHomeTrailPheromone)
                this.ant_home_trail_pheromone_id = i;
            else if (scene.affectorGroups(i).group_type == EnvAffectorType.antFoodTrailPheromone) {
                this.ant_food_trail_pheromone_id = i;
            }
            else if (scene.affectorGroups(i).group_type == EnvAffectorType.Food)
                this.food_affector_id = i;
        }
    }

    public def stepActors():void {
        for (var i:Int = 0; i < this.size; i++) {

            if (!this.alive(i))
                continue;

            var env:ArrayList[Pair[Int,Int]] = this.scene.envAffectorQuery(this.pos(3*i), this.pos(3*i+1), 0, rand.nextInt(maxValue) as Double);

            //move out in a random direction, with some variance.
            var dir:Array[double](1) = [0.0 as double,0.0 as double,0.0 as double];
            if (dir == [0.0,0.0,0.0]) {
                Console.OUT.println("ZERO ACKNOWLEDGED");
            	val range_mod:double = this.step_distance/2;
                dir = [rand.nextDouble()*this.step_distance - range_mod,
            	       rand.nextDouble()*this.step_distance - range_mod,
            	       0.0];
            	
            } else { //perturb, but mainly stay along original dir.
                val factor:double = 1/10.0;
                val factor_mod:double = factor/2;
                dir(0) += rand.nextDouble()*this.step_distance*factor - factor_mod;
                dir(1) += rand.nextDouble()*this.step_distance*factor - factor_mod;
            }
            
            
            
            
            
            // if ((this.pos(3*i) == 0) && (this.pos(3*i+1) == 0) || env.empty()) {
            //     val x = rand.nextInt(maxValue) as Double;
            //     val y = rand.nextInt(maxValue) as Double;
            //     this.pos(3*i) += x;
            //     this.pos(3*i+1) += y;
            //     this.scene.affectorGroups(this.returnAffector).pos.add(x);
            //     this.scene.affectorGroups(this.returnAffector).pos.add(y);
            //     this.scene.affectorGroups(this.returnAffector).pos.add(0);
            // } 

            
            
        }
    }                



    def envFind(i:Int, env:ArrayList[Pair[Int,Int]]):Boolean {
        var j:Pair[Int, Int];
        for (var x:Int = 0; x < env.size(); x++) {
            j = env(x);
            if(j.first == i)
                return true;
        }
        return false;
    }
    
}
