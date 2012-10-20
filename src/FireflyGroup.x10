public class FireflyGroup extends ActorGroup {
    val actorFlashFreq:Array[Int] = new Array[Int](numActors, (p:Int) => rand.nextInt(maxValue));

    def this(n:Int) {
        this.numActors = n;
        this.actorPos = new Array[Double](3*numActors);
        this.actorHealth = new Array[Double](numActors, (p:Int) => 100.0);
    }

    def updateScene():void {
        this.updatePos();
        this.updateHealth();
    }

    def updatePos():void {
        for (var i:Int = 0; i < numActors; i++) {
            if (!this.alive(i))
                continue;            
            this.actorPos(3*i+1) += rand.nextInt(maxValue) as Double;
            this.actorPos(3*i+2) += rand.nextInt(maxValue) as Double;
            this.actorPos(3*i+3) += rand.nextInt(maxValue) as Double;
        }
    }
}