public class AntGroup extends ActorGroup {
    def this(n:Int) {
        this.size = n;
        this.actorPos = new Array[Double](3*size);
        this.actorHealth = new Array[Double](size, (p:Int) => 100.0);  
    }

    def this(n:Int, r:Box) {
        this.numActors = n;
        this.actorPos = new Array[Double](3*numActors);
        for (var i:Int = 0; i < numActors; i++) {

            var x:Double = rand.nextInt(maxValue) as Double;
            var y:Double = rand.nextInt(maxValue) as Double;
            var z:Double = rand.nextInt(maxValue) as Double;

            while (!r.contained(x, y, z)) {
                x = rand.nextInt(maxValue) as Double;
                y = rand.nextInt(maxValue) as Double;
                z = rand.nextInt(maxValue) as Double;
            }

            this.actorPos(3*i+1) = x;
            this.actorPos(3*i+2) = y;
            this.actorPos(3*i+3) = z;
        }

        this.actorHealth = new Array[Double](numActors, (p:Int) => 100.0);
    }

    def this(n:Int, Pos:Array[Double]) {
        this.numActors = n;
        this.actorPos = new Array[Double](3*numActors, (p:Int) => Pos(p));
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
        }
    }
}