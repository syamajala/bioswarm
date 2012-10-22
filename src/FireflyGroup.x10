import x10.util.ArrayList;
import x10.util.Pair;

public class FireflyGroup extends ActorGroup {
    var actorFlashFreq:Array[Int]; 
    var actorFlashing:Array[Boolean];
    var actorCurIntensity:Array[Double];
    var stepCount:Array[Int];
    var actorFlashIntensity:Array[Double];
    
    def this(n:Int, scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => 0.0);
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.scene = scene;
        this.acttype = ActorType.Firefly;
        this.actorFlashFreq = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));
        this.actorFlashing =  new Array[Boolean](size, (p:Int) => false);
        this.stepCount =  new Array[Int](size, (p:Int) => 0);
        this.actorFlashIntensity = new Array[Double](size, (p:Int) => rand.nextInt(maxValue) as Double);
        this.actorCurIntensity = new Array[Double](size, (p:Int) => 0.0);
    }

    def this(n:Int, r:Box, scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size);
        for (var i:Int = 0; i < size; i++) {
            this.pos(3*i) = rand.nextInt(r.l as Int) as Double + r.v1(0);
            this.pos(3*i+1) = rand.nextInt(r.w as Int) as Double + r.v1(1);
            this.pos(3*i+2) = rand.nextInt(r.h as Int) as Double;
        }

        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.scene = scene;
        this.acttype = ActorType.Firefly;
        this.actorFlashFreq = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));
        this.actorFlashing =  new Array[Boolean](size, (p:Int) => false);
        this.stepCount =  new Array[Int](size, (p:Int) => 0);
        this.actorFlashIntensity = new Array[Double](size, (p:Int) => rand.nextInt(maxValue) as Double);
        this.actorCurIntensity = new Array[Double](size, (p:Int) => 0.0);
    }

    def this(n:Int, pos:Array[Double], scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => pos(p));
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.scene = scene;
        this.acttype = ActorType.Firefly;
        this.actorFlashFreq = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));
        this.actorFlashing =  new Array[Boolean](size, (p:Int) => false);
        this.stepCount =  new Array[Int](size, (p:Int) => 0);
        this.actorFlashIntensity = new Array[Double](size, (p:Int) => rand.nextInt(maxValue) as Double);
        this.actorCurIntensity = new Array[Double](size, (p:Int) => 0.0);
    }

    public def stepActors():void {
        for (var i:Int = 0; i < this.size; i++) {
            if (!this.alive(i))
                continue;

            if (this.stepCount(i) == this.actorFlashFreq(i)) {
                this.actorFlashing(i) = true;
                this.stepCount(i) = 0;
                this.actorCurIntensity(i) = this.actorFlashFreq(i);
            }
            else {
                this.actorFlashing(i) = false;
                this.actorCurIntensity(i) = this.actorCurIntensity(i) - 1;
                this.stepCount(i) = this.stepCount(i) + 1;
                }
            
            var env:ArrayList[Pair[Int,Int]] = this.scene.actorQuery(this.pos(3*i), this.pos(3*i+1), this.pos(3*i+2), rand.nextInt(2*maxValue) as Double);
            
            if (env.isEmpty() || ((this.pos(3*i) == 0.0) && (this.pos(3*i+1) == 0.0) && (this.pos(3*i+2) == 0.0))) {
                this.pos(3*i) += rand.nextInt(2*maxValue)-maxValue as Double;
                this.pos(3*i+1) += rand.nextInt(2*maxValue)-maxValue as Double;
                this.pos(3*i+2) += rand.nextInt(2*maxValue)-maxValue as Double;                        
            } else {
                var fireflygroup:Int = -1;
                for (var j:Int = 0; j < this.scene.actorGroups.size; j++) {
                    if (this.scene.actorGroups(j).acttype == ActorType.Firefly) {
                        fireflygroup = j;
                        break;
                    }
                }
                if (fireflygroup != -1) {
                    var a:Int = this.envFind(fireflygroup, env, i);
                    if (a != -1) {                        
                            this.pos(3*i) = this.pos(3*a) + 2;
                            this.pos(3*i+1) = this.pos(3*a+1) + 2;
                            this.pos(3*i+2) = this.pos(3*a+2) + 2;
                    }
                    else {
                        this.pos(3*i) += rand.nextInt(2*maxValue)-maxValue as Double;
                        this.pos(3*i+1) += rand.nextInt(2*maxValue)-maxValue as Double;
                        this.pos(3*i+2) += rand.nextInt(2*maxValue)-maxValue as Double;                        
                    }                    
                } else {
                        this.pos(3*i) += rand.nextInt(2*maxValue)-maxValue as Double;
                        this.pos(3*i+1) += rand.nextInt(2*maxValue)-maxValue as Double;
                        this.pos(3*i+2) += rand.nextInt(2*maxValue)-maxValue as Double;
                }        
            }
        }
    }

    def envFind(i:Int, env:ArrayList[Pair[Int,Int]], c:Int):Int {
        var j:Pair[Int, Int];
        for (var x:Int = 0; x < env.size(); x++) {
            j = env(x);
            if (j.first == i) {
                if (this.actorCurIntensity(j.second) > this.actorCurIntensity(c))
                    return x;
            }
        }
        return -1;
    }
}