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
    
    
    def loadScene():void {
        // initialize the scene with actors, environment props, food, etc. here.
        this.VF_loadScene001(); //keeping our test cases separate and clean.
    }
    
    // TODO: replace the need for these functions with scene files.
    def VF_loadScene001():void {
        this.start_frame = 1;
        this.end_frame = 50;
        
        this.actorGroups = new Array[ActorGroup](2);
        
        this.actorGroups(0) = new FireflyGroup(500);
        this.actorGroups(1) = new AntGroup(500);
        
        this.affectorGroups = new Array[EnvAffectorGroup](2);
        this.affectorGroups(0) = new FireGroup(100);
        this.affectorGroups(1) = new FoodGroup(100);
        for (var i:Int = 0; i < actorGroups.size; i++)
            actorGroups(i).scene = this;
    }

    def VF_loadScene002():void {
        this.start_frame = 1;
        this.end_frame = 10;

        this.actorGroups = new Array[ActorGroup](1);
        val p = new Array[Double](3, (p:Int) => 0.0);
        val b = new Box(50.0, 50.0, 50.0, p);
        this.actorGroups(0) = new AntGroup(100, b);
        
        this.affectorGroups = new Array[EnvAffectorGroup](1);
        this.affectorGroups(0) = new FireGroup(10, b);
        
        for (var i:Int = 0; i < actorGroups.size; i++)
            actorGroups(i).scene = this;
    }
        
    def stepScene():void {
        for (var ag:Int = 0; ag < actorGroups.size; ag++) {
            actorGroups(ag).updateScene();
        }

        //TODO: remove this and have a reference to the scene be passed in at the constructor of an actorgroup.
        for (var i:Int = 0; i < actorGroups.size; i++)
            actorGroups(i).scene = this;
        
        this.current_frame++;
    }

    //TODO: set up an acceleration structure so we prune affectors that are too far away to be checked (spatial hashmap, 3d grid).
    // returns pairs of integers that represent which group an affector is in, and its index within that group.
    // this pair of numbers can be used to get the affector position, or any other attribute from the scene.
    // e.g. for position: scene.affectorGroups(group).pos(3*aff) gets the x position of affector aff in affector group, group.
    def envAffectorQuery(x:double, y:double, z:double, radius:double):ArrayList[Pair[int, int]] {
        var result:ArrayList[Pair[int,int]] = new ArrayList[Pair[int, int]]();
        
        for (var group:int = 0; group < this.affectorGroups.size; group++) {
            for (var aff:int = 0; aff < this.affectorGroups(group).size; aff++) {
                if (distToAffector(x, y, z, group, aff) < radius) {
                	result.add(new Pair(group, aff));
                }
            }
        }
        
        return result;
    }
    
    private def distToAffector(x:double, y:double, z:double, group:int, aff:int) : double {
        return Math.sqrt(Math.pow((x-this.affectorGroups(group).pos(3*aff)), 2)
                			 + Math.pow((y-this.affectorGroups(group).pos(3*aff + 1)), 2)
                			 + Math.pow((z-this.affectorGroups(group).pos(3*aff + 2)), 2));
    }
    
    
    def actorQuery(x:double, y:double, z:double, radius:double) : ArrayList[Pair[int, int]] {
        var result:ArrayList[Pair[int,int]] = new ArrayList[Pair[int,int]]();
        
        for (var group:int = 0; group < this.actorGroups.size; group++) {
            for (var actor:int = 0; actor < this.actorGroups(group).size; actor++) {
                if (distToActor(x,y,z,group,actor) < radius) {
                	result.add(new Pair(group, actor));
                }
            }
        }
        
        return result;
    }
    
    private def distToActor(x:double, y:double, z:double, group:int, actor:int) : double {
        return Math.sqrt(Math.pow((x-this.actorGroups(group).pos(3*actor)), 2)
                + Math.pow((y-this.actorGroups(group).pos(3*actor + 1)), 2)
                + Math.pow((z-this.actorGroups(group).pos(3*actor + 2)), 2));
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




