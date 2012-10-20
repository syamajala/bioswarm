import x10.util.ArrayList;

public class Scene {
    var start_frame:Int;
    var end_frame:Int;
    var actorGroups:ArrayList[ActorGroup];
    //var propGroups:Array[EnvAffectorGroup](1);
    
    //TODO: make this use a file.
    def loadScene():void {
        // initialize the scene with actors, environment props, food, etc. here.
        this.start_frame = 0;
        this.end_frame = 1000;
        
        this.actorGroups = new ArrayList[ActorGroup]();
        
        this.actorGroups.add(new FireflyGroup(500));
        this.actorGroups.add(new AntGroup(500));
        
    }
    
    def stepScene():void {
        for (ag in actorGroups) {
            ag.updateScene();
        }
    }

    def envQuery(x:Double, y:Double, z:Double, d:Double):Boolean {
        for (var i:Int = 0; i < actorGroups.size; i++) {
            if (Math.sqrt(Math.pow((x-propGroups(i)(0)), 2) + Math.pow((y-propGroups(i)(1)), 2) + Math.pow((z-propGroups(i)(2)), 2)) <= d)
                return true;
        }
        return false;
    }
    
}