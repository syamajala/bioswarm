import x10.util.Random;

public abstract class ActorGroup {
    var numActors:Int;
    var actorid:Array[Int](1);
    var actorPos:Array[Int](1);
    var actorHealth:Array[Int](1);
    
    static val rand = new Random(System.nanoTime());
    static val maxValue = 10;

    abstract def updateScene():void;
    abstract def updatePos():void;
    
    def alive(i:Int):Boolean {
	if (this.actorHealth(i) != 0) 
	    return true;
	else 
	    return false;
    }
    
    def updateHealth():void {
	for (var i:Int = 0; i < this.numActors; i++) {
	    if (this.alive(i))
		this.actorHealth(i)--;
	}
    }
}
