public class FireflyGroup extends ActorGroup {
    val actorFlashFreq:Array[Int] = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));

    def this(n:Int) {
        this.size = n;
        this.actorPos = new Array[Double](3*size);
        this.actorHealth = new Array[Double](size, (p:Int) => 100.0);
    }

    def updateScene():void {
        this.updatePos();
        this.updateHealth();
    }

    def updatePos():void {
        for (var i:Int = 0; i < size; i++) {
            if (this.alive(i)) {
                this.actorPos(3*i+1) += rand.nextInt(maxValue) as Double;
                this.actorPos(3*i+2) += rand.nextInt(maxValue) as Double;
                this.actorPos(3*i+3) += rand.nextInt(maxValue) as Double;
            }
        }
    }
}