import x10.util.Random;

public abstract class ActorGroup {
    var size:Int;
    var actorPos:Array[Double](1);
    var actorHealth:Array[Double](1);
    var onAffector:Array[Boolean](1);
    var scene:Scene;

    static val rand = new Random(System.nanoTime());
    static val maxValue = 10;

    abstract def updateScene():void;
    
    def alive(i:Int):Boolean {
        if (this.actorHealth(i) < 1e-6) { 
            return false;
        } else { 
            return true;
        }
    }
    

}
