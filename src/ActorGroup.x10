import x10.util.Random;

public abstract class ActorGroup {
    var size:Int;
    var pos:Array[Double](1);
    var health:Array[Double](1);
    //var digestion_rate:Array[Double](1);
    var on_affector:Array[Boolean](1);
    var scene:Scene;
    
    static val rand = new Random(System.nanoTime());
    static val maxValue = 10;
    public abstract def stepActors():void;
    
    def alive(i:Int):Boolean {
        if (this.health(i) < 1e-6) { 
            return false;
        } else { 
            return true;
        }
    }
    

}
