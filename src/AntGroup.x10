import x10.util.ArrayList;
import x10.util.Pair;

public class AntGroup extends ActorGroup {
    def this(n:Int, scene:Scene) {
        this.size = n;
        //        this.pos = new Array[Double](3*size, (p:Int) => ((p%3) == 2) ? 0.0 : rand.nextInt(1000) as Double);
        this.pos = new Array[Double](3*size, (p:Int) => 0.0);
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.metabolism = new Array[Double](size, (p:Int) => 0.0);
        this.on_affector = new Array[Boolean](size, (p:Int) => false);
        this.scene = scene;
        
        for (var i:Int = 0; i < scene.affectorGroups; i++) {
            if (scene.affectorGroups(i).afftype == afftype.antReturnPath)
                this.returnAffector = i;
            else if (scene.affectorGroups(i).afftype == afftype.antFoundFood)
                this.foodAffector = i;
        }
    }

    def this(n:Int, r:Box, scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size);
        for (var i:Int = 0; i < size; i++) {

            var x:Double = rand.nextInt(r.l as Int) as Double + r.v1(0);
            var y:Double = rand.nextInt(r.w as Int) as Double + r.v1(1);
            var z:Double = 0;

            while (!r.contained(x, y, z)) {
                x = rand.nextInt(r.l as Int) as Double + r.v1(0);
                y = rand.nextInt(r.w as Int) as Double + r.v1(1);
            }

            this.pos(3*i) = x;
            this.pos(3*i+1) = y;
            this.pos(3*i+2) = z;
        }

        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.metabolism = new Array[Double](size, (p:Int) => 0.0);
        this.on_affector = new Array[Boolean](size, (p:Int) => false);
        this.scene = scene;
        
        for (var i:Int = 0; i < scene.affectorGroups; i++) {
            if (scene.affectorGroups(i).afftype == afftype.antReturnPath)
                this.returnAffector = i;
            else if (scene.affectorGroups(i).afftype == afftype.antFoundFood)
                this.foodAffector = i;
        }
    }

    def this(n:Int, pos:Array[Double], scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => pos(p));
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.metabolism = new Array[Double](size, (p:Int) => 0.0);
        this.on_affector = new Array[Boolean](size, (p:Int) => false);

        this.scene = scene;
        
        for (var i:Int = 0; i < scene.affectorGroups; i++) {
            if (scene.affectorGroups(i).afftype == afftype.antReturnPath)
                this.returnAffector = i;
            else if (scene.affectorGroups(i).afftype == afftype.antFoundFood)
                this.foodAffector = i;
        }
    }

    def updateScene():void {
        for (var i:Int = 0; i < size; i++) {

            if (!this.alive(i))
                continue;

            var env:ArrayList[Pair[Int,Int]] = this.scene.envAffectorQuery(this.pos(3*i), this.pos(3*i+1), 0, rand.nextInt(maxValue) as Double);


            if ((this.pos(3*i) == 0) && (this.pos(3*i+1) == 0) || env.empty()) {
                val x = rand.nextInt(maxValue) as Double;
                val y = rand.nextInt(maxValue) as Double; 
                this.pos(3*i) += x;
                this.pos(3*i+1) += y;
                this.scene.affectorGroups(this.returnAffector).pos.add(x);
                this.scene.affectorGroups(this.returnAffector).pos.add(y);
                this.scene.affectorGroups(this.returnAffector).pos.add(0);
            } 

            /*else if (this.envFind(this.returnAffector, env)) {
                env(this.returnAffector)
            this.pos(3*i) = scene.affectorGroups(j.first).pos(3*j.second);
                this.pos(3*i+1) = scene.affectorGroups(j.first).pos(3*j.second+1);
                this.on_affector(i) = true;
                if (scene.affectorGroups(j.first).afftype == afftypes.Fire)
                    this.health(i) = 0.0;
                else if (scene.affectorGroups(j.first).afftype == afftypes.Food) {
                    var a:FoodGroup = scene.affectorGroups(j.first) as FoodGroup;
                    if (a.available(j.second)) {
                        a.quantity(j.second) = a.quantity(j.second) - 1;
                        this.metabolism(i)++;
                        }*/
        }
    }                



    def envFind(i:Int, env:ArrayList[Pair[Int,Int]]):Boolean {
        var j:Pair[Int, Int];
        for (var x:Int = 0; x < env.size(); x++) {
            j = env(x);
            if(j.first == i)
                return true;
        }
        return false;
    }
    
}
