import x10.util.ArrayList;
import x10.util.Pair;
import x10.io.Printer;
import x10.io.IOException;

public class Scene {
    var start_frame:Int;
    var end_frame:Int;
    var current_frame:Int;
    
    var actorGroups:Array[ActorGroup];
    var affectorGroups:Array[EnvAffectorGroup];
        
    def loadScene(n:Int):void {
        // initialize the scene with actors, environment props, food, etc. here.

        switch (n) {
        case 0:
            Console.OUT.println("Loading scene 0");
            this.VF_loadScene000();
            break;
        case 1:
            Console.OUT.println("Loading scene 1");
            this.VF_loadScene001();
            break;
        case 2:            
            Console.OUT.println("Loading scene 2");
            this.VF_loadScene002(); //keeping our test cases separate and clean.
            break;
        default:
            throw new Exception("Undefined scene file");     
        }
    }
    
    // TODO: replace the need for these functions with scene files.
    def VF_loadScene000():void {
        this.start_frame = 1;
        this.end_frame = 1000;
        
        // want food, home trail phero, and food trail phero affectors.
        this.affectorGroups = new Array[EnvAffectorGroup](2);
        this.affectorGroups(0) = new FoodGroup(1, [50.0, 50.0, 0.0]);
        this.affectorGroups(1) = new HiveEntranceGroup(1, [0.0 as double,0.0 as double,0.0 as double]);
        // this.affectorGroups(2) = new PheromoneGroup(EnvAffectorType.antFoodTrailPheromone, 2.0);
        
        this.actorGroups = new Array[ActorGroup](1);
        this.actorGroups(0) = new AntGroup(100, this);
    }
    
    def VF_loadScene001():void {
        this.start_frame = 1;
        this.end_frame = 1000;

        this.affectorGroups = new Array[EnvAffectorGroup](2);
        this.affectorGroups(0) = new HiveEntranceGroup(1, [0.0 as double,0.0 as double,0.0 as double]);
        var pos:Array[Double] =  [-75.0, -90.0, 0.0];
        this.affectorGroups(1) = new FoodGroup(1, pos);
                
        this.actorGroups = new Array[ActorGroup](2);

        val p = new Array[Double](3, (p:Int) => 10.0);
        val b = new Box(50.0, 50.0, 50.0, p);

        this.actorGroups(0) = new FireflyGroup(500, 0, this);
        this.actorGroups(1) = new AntGroup(500, this);
    }

    def VF_loadScene002():void {
        this.start_frame = 1;
        this.end_frame = 1000;

        val p = new Array[Double](3, (p:Int) => 0.0);
        val b = new Box(10.0, 10.0, 10.0, p);
     
        this.affectorGroups = new Array[EnvAffectorGroup](1);
        this.affectorGroups(0) = new FireGroup(10);
        this.actorGroups = new Array[ActorGroup](1);
        this.actorGroups(0) = new FireflyGroup(100, b, 0, this);
    }

    def serialstepScene():void {
        for (var ag:int = 0; ag < this.actorGroups.size; ag++) {        
               this.actorGroups(ag).serialstepActors();
        }
        
        if (this.affectorGroups.size != 0) {
            for (var pg:int = 0; pg < this.affectorGroups.size; pg++) {
                this.affectorGroups(pg).stepDynamicAttributes();
            }
        }
        this.current_frame++;
    }
        
    def parallelstepScene():void {
        if (this.actorGroups.size > 1) {
            finish for (var ag:int = 0; ag < this.actorGroups.size; ag++) {
                val g = ag;
                async this.actorGroups(g).parallelstepActors();
            }
        } else {
            this.actorGroups(0).parallelstepActors();
        }
        
        if (this.affectorGroups.size != 0) {
            for (var pg:int = 0; pg < this.affectorGroups.size; pg++) {
                this.affectorGroups(pg).stepDynamicAttributes();
            }
        }
        this.current_frame++;
    }

    def actorQuery(x:double, y:double, z:double, radius:double) : ArrayList[Pair[int, int]] {
        var result:ArrayList[Pair[int,int]] = new ArrayList[Pair[int,int]]();        
        for (var group:int = 0; group < this.actorGroups.size; group++) {
            for (var actor:int = 0; actor < this.actorGroups(group).size; actor++) {
                if ((distToActor(x,y,z,group,actor) < radius) &&
                    ((x != this.actorGroups(group).pos(3*actor)) &&
                     (y != this.actorGroups(group).pos(3*actor + 1)) &&
                     (z != this.actorGroups(group).pos(3*actor + 2)))) {
                    result.add(new Pair(group, actor));
                }
            }
        }        
        return result;
    }

    def distToActor(x:double, y:double, z:double, group:int, actor:int) : double {
        return Math.sqrt(Math.pow((x-this.actorGroups(group).pos(3*actor)), 2)
                         + Math.pow((y-this.actorGroups(group).pos(3*actor + 1)), 2)
                         + Math.pow((z-this.actorGroups(group).pos(3*actor + 2)), 2));
    }    


    //TODO: set up an acceleration structure so we prune affectors that are too far away to be checked (spatial hashmap, 3d grid).
    // returns pairs of integers that represent an affector group's id, and its index within that group.
    // this pair of numbers can be used to get the affector position, or any other attribute from the scene.
    // e.g. for position: scene.affectorGroups(group).pos(3*aff) gets the x position of affector aff in affector group, group.
    def envAffectorQuery(x:Double, y:Double, z:Double, radius:Double):ArrayList[Pair[Int, Int]] {
        var result:ArrayList[Pair[Int,Int]] = new ArrayList[Pair[Int, Int]]();

        for (var group:Int = 0; group < this.affectorGroups.size; group++) {
            for (var aff:Int = 0; aff < this.affectorGroups(group).size; aff++) {
                if (distToAffector(x, y, z, group, aff) < radius) {
                	result.add(new Pair(this.affectorGroups(group).group_type, aff));
                }
            }
        }
        
        return result;
    }
    
    def distToAffector(x:double, y:double, z:double, group:int, aff:int) : double {
        return Math.sqrt(Math.pow((x-this.affectorGroups(group).pos(3*aff)), 2)
                			 + Math.pow((y-this.affectorGroups(group).pos(3*aff + 1)), 2)
                			 + Math.pow((z-this.affectorGroups(group).pos(3*aff + 2)), 2));
    }
    
    
    /*
     * scene output functions
     */
    
    def outputSimState(output:Printer) {
        try {
            
            output.println("FRAME " + this.current_frame);
            
            printActorGroupPositions(output);
            
        } catch (IOException) {
            Console.OUT.println("ERROR || outputSimState: exception during dump of sim state at frame" + this.current_frame);
        }
    }
    
    def printActorGroupPositions (output_printer:Printer) : void {
        for (var group_id:int=0; group_id < this.actorGroups.size; group_id++) {
	        for (var actor_id:int=0; actor_id < this.actorGroups(group_id).size; actor_id++) {
	            var outstr:String = ("ACTOR; GROUP=" + group_id + "; ID=" + actor_id + "; ");
	            val group:ActorGroup = this.actorGroups(group_id);
	            outstr += "POS=(" + group.pos(3*actor_id) + "," + group.pos(3*actor_id+1) + "," + group.pos(3*actor_id+2) + "); ";
	            
	            output_printer.println(outstr);
	        }
        }
    }
    
    
    
}




