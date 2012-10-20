public class AntGroup extends ActorGroup {
    def this(n:Int) {
	numActors = n;
	actorid = new Array[Int](numActors, (p:Int) => p);
	actorPos = new Array[Int](3*numActors);
	actorHealth = new Array[Int](numActors, (p:Int) => 100);	
    }

    def updateScene():void {
	this.updatePos();
	this.updateHealth();
    }

    def updatePos():void {
	for (var i:Int = 0; i < numActors; i++) {
	    if (this.alive(i)) {
		this.actorPos(3*i+1) += rand.nextInt(maxValue);
		this.actorPos(3*i+2) += rand.nextInt(maxValue);
	    }
	}
    }
        
}