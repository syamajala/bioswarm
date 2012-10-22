import x10.util.ArrayList;
import x10.util.Pair;

public class FireflyGroup extends ActorGroup {
    val actorFlashFreq:Array[Int] = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));

    def this(n:Int, scene:Scene) {
        this.scene = scene;
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => rand.nextInt(1000) as Double);
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.on_affector = new Array[Boolean](size, (p:Int) => false);
    }

    def this(n:Int, r:Box) {
        this.size = n;
        this.pos = new Array[Double](3*size);
        for (var i:Int = 0; i < size; i++) {

            var x:Double = rand.nextInt(r.l as Int) as Double + r.v1(0);
            var y:Double = rand.nextInt(r.w as Int) as Double + r.v1(1);
            var z:Double = rand.nextInt(r.h as Int) as Double;

            this.pos(3*i) = x;
            this.pos(3*i+1) = y;
            this.pos(3*i+2) = z;
        }

        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.on_affector = new Array[Boolean](size, (p:Int) => false);
    }

    def this(n:Int, pos:Array[Double]) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => pos(p));
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.on_affector = new Array[Boolean](size, (p:Int) => false);
    }

    public def stepActors():void {
        for (var i:Int = 0; i < this.size; i++) {
            if (!this.alive(i))
                continue;

            var env:ArrayList[Pair[Int,Int]] = this.scene.envAffectorQuery(this.pos(3*i), this.pos(3*i+1), 0, rand.nextInt(maxValue) as Double);

            if (env.isEmpty() || this.on_affector(i)) {
                this.pos(3*i) += rand.nextInt(maxValue) as Double;
                this.pos(3*i+1) += rand.nextInt(maxValue) as Double;
                this.pos(3*i+2) += rand.nextInt(maxValue) as Double;
                this.on_affector(i) = false;
            } else {
                var j:Pair[Int, Int] = env(rand.nextInt(env.size()));
                this.pos(3*i) = scene.affectorGroups(j.first).pos(3*j.second);
                this.pos(3*i+1) = scene.affectorGroups(j.first).pos(3*j.second+1);
                this.pos(3*i+2) += scene.affectorGroups(j.first).pos(3*j.second+2);
                this.on_affector(i) = true;
                if (scene.affectorGroups(j.first).group_type == EnvAffectorType.Fire)
                    this.health(i) = 0.0;
                else if (scene.affectorGroups(j.first).group_type == EnvAffectorType.Food) {
                    var a:FoodGroup = scene.affectorGroups(j.first) as FoodGroup;
                    if (a.available(j.second)) {
                        a.quantity(j.second) = a.quantity(j.second) - 1;
                    }
                }
            } 
        }
    }
}