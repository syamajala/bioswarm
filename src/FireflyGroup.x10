public class FireflyGroup extends ActorGroup {
    val actorFlashFreq:Array[Int] = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));

    def this(n:Int) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => rand.nextInt() as Double);
        this.health = new Array[Double](size, (p:Int) => 100.0);
    }

    def this(n:Int, r:Box) {
        this.size = n;
        this.pos = new Array[Double](3*size);
        for (var i:Int = 0; i < size; i++) {

            var x:Double = rand.nextInt(r.l as Int) as Double + r.v1(0);
            var y:Double = rand.nextInt(r.w as Int) as Double + r.v1(1);
            var z:Double = rand.nextInt(r.h as Int) as Double;

            while (!r.contained(x, y, z)) {
                x = rand.nextInt(r.l as Int) as Double + r.v1(0);
                y = rand.nextInt(r.w as Int) as Double + r.v1(1);
                z = rand.nextInt(r.h as Int) as Double;
            }

            this.pos(3*i) = x;
            this.pos(3*i+1) = y;
            this.pos(3*i+2) = z;
        }

        this.health = new Array[Double](size, (p:Int) => 100.0);
    }

    def this(n:Int, pos:Array[Double]) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => pos(p));
        this.health = new Array[Double](size, (p:Int) => 100.0);
    }

    def updateScene():void {
        for (var i:Int = 0; i < this.size; i++) {
            if (!this.alive(i))
                continue;
            this.pos(3*i) += rand.nextInt(maxValue) as Double;
            this.pos(3*i+1) += rand.nextInt(maxValue) as Double;
            this.pos(3*i+2) += rand.nextInt(maxValue) as Double;           
            //this.health(i)--;      
        }
    }
}