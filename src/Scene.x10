import x10.util.ArrayList;
import x10.util.Pair;

public class Scene {
    var start_frame:Int;
    var end_frame:Int;
    var num_actor_groups:Int;
    var num_affector_groups:Int;
    
    var actorGroups:Array[ActorGroup];
    var affectorGroups:Array[EnvAffectorGroup];
    
    
    def loadScene():void {
        // initialize the scene with actors, environment props, food, etc. here.
        this.VF_loadScene001(); //keeping our test cases separate and clean.
        
        
    }
    
    // TODO: replace the need for these functions with scene files.
    def VF_loadScene001():void {
        this.start_frame = 0;
        this.end_frame = 1000;
        this.num_actor_groups = 2;
        this.num_affector_groups = 1;
        
        this.actorGroups = new Array[ActorGroup](this.num_actor_groups);
        
        this.actorGroups(0) = new FireflyGroup(500);
        this.actorGroups(1) = new AntGroup(500);
        
        this.affectorGroups = new Array[EnvAffectorGroup](this.num_affector_groups);
        this.affectorGroups(0) = new PheromoneGroup();
    }
    
    def stepScene():void {
        for (var ag:Int = 0; ag < actorGroups.size; ag++) {
            actorGroups(ag).updateScene();
        }
    }

    //TODO: set up an acceleration structure so we prune affectors that are too far away to be checked (spatial hashmap, 3d grid).
    // returns pairs of integers that represent which group an affector is in, and its index within that group.
    // this pair of numbers can be used to get the affector position, or any other attribute from the scene.
    // e.g. for position: scene.affectorGroups(group).pos(3*aff) gets the x position of affector aff in affector group, group.
    def envAffectorQuery(x:Double, y:Double, z:Double, radius:Double):ArrayList[Pair[Int, Int]] {
        var result:ArrayList[Pair[Int,Int]] = new ArrayList[Pair[Int, Int]]();
        
        for (var group:Int = 0; group < this.affectorGroups.size; group++) {
            for (var aff:Int = 0; aff < this.affectorGroups(group).size; aff++) {
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
    
    
    
    
//     def envQuery(x:Double, y:Double, z:Double, d:Double):Boolean {
//         for (var i:Int = 0; i < propGroups.size; i++) {
//             if (Math.sqrt(Math.pow((x-propGroups(i)(0)), 2) + Math.pow((y-propGroups(i)(1)), 2) + Math.pow((z-propGroups(i)(2)), 2)) <= d)
//                 return true;
//         }
//         return false;
//     }
    
}