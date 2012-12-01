import x10.util.Random;

public abstract class ActorGroup {
    var size:Int;
    var pos:Array[Double](1);
    var health:Array[Double](1);
    //var digestion_rate:Array[Double](1);
    var on_affector:Array[Boolean](1);
    var scene:Scene;
    var acttype:Int;    
    var rand:Random;
    static val maxValue = 10;
    public abstract def serialstepActors():void;
    public abstract def parallelstepActors(num_threads:int):void;
    def alive(i:Int):Boolean {
        if (this.health(i) < 1.0) { 
            return false;
        } else { 
            return true;
        }
    }
    

}
