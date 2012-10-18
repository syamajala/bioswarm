public class FireflyGroup extends ActorGroup {
    var numActors:Int;
    val actorFlashFreq:Array[Int] = new Array[Int](numActors);

    def this(n:Int) {
	numActors = n;
	actorid = new Array[Int](numActors);
	actorPos = new Array[Int](numActors);
	actorHleath = new Array[Int](numActors);
    }

    def updateScene():void {
	// do stuff
    }
}
