import x10.util.ArrayList;
import x10.util.Pair;

public class AntGroup extends ActorGroup {
    def this(n:Int) {
        this.size = n;
        this.actorPos = new Array[Double](3*size, (p:Int) => rand.nextInt() as Double);
        this.actorHealth = new Array[Double](size, (p:Int) => 100.0);
        this.onAffector = new Array[Boolean](size, (p:Int) => false);
    }

    def this(n:Int, r:Box) {
        this.size = n;
        this.actorPos = new Array[Double](3*size);
        for (var i:Int = 0; i < size; i++) {

            var x:Double = rand.nextInt(r.l as Int) as Double + r.v1(0);
            var y:Double = rand.nextInt(r.w as Int) as Double + r.v1(1);
            var z:Double = 0;

            while (!r.contained(x, y, z)) {
                x = rand.nextInt(r.l as Int) as Double + r.v1(0);
                y = rand.nextInt(r.w as Int) as Double + r.v1(1);
            }

            this.actorPos(3*i+1) = x;
            this.actorPos(3*i+2) = y;
            this.actorPos(3*i+3) = z;
        }

        this.actorHealth = new Array[Double](size, (p:Int) => 100.0);
        this.onAffector = new Array[Boolean](size, (p:Int) => false);
    }

    def this(n:Int, pos:Array[Double]) {
        this.size = n;
        this.actorPos = new Array[Double](3*size, (p:Int) => pos(p));
        this.actorHealth = new Array[Double](size, (p:Int) => 100.0);
        this.onAffector = new Array[Boolean](size, (p:Int) => false);
    }

    def updateScene():void {
        for (var i:Int = 0; i < size; i++) {

            if (!this.alive(i))
                continue;

            var env:ArrayList[Pair[Int,Int]] = this.scene.envAffectorQuery(this.actorPos(3*i+1), this.actorPos(3*i+2), 0, rand.nextInt(maxValue) as Double);

            if (env.isEmpty() || this.onAffector(i)) {
                this.actorPos(3*i+1) += rand.nextInt(maxValue) as Double;
                this.actorPos(3*i+2) += rand.nextInt(maxValue) as Double;
                this.onAffector(i) = false;
            } else {
                var j:Pair[Int, Int] = env(rand.nextInt(env.size()));
                this.actorPos(3*i+1) = scene.affectorGroups(j.first).pos(3*j.second);
                this.actorPos(3*i+2) = scene.affectorGroups(j.first).pos(3*j.second+1);
                this.onAffector(i) = true;
                //                if (scene.affectorGroups(j.first).type == "Hazard") 
                //                    this.actorHealth(i)--;
            }
        }
    }
}