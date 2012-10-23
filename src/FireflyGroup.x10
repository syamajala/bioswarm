import x10.util.ArrayList;
import x10.util.Pair;

public class FireflyGroup extends ActorGroup {
    var actorFlashFreq:Array[Int]; 
    var actorCurIntensity:Array[Double];
    var stepCount:Array[Int];
    var actorFlashIntensity:Array[Double];

    // initialize position of all actors to hive location
    def this(n:Int, scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => 0.0);
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.scene = scene;
        this.acttype = ActorType.Firefly;
        this.actorFlashFreq = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));
        this.stepCount =  new Array[Int](size, (p:Int) => 0);
        this.actorFlashIntensity = new Array[Double](size, (p:Int) => maxValue*rand.nextDouble());
        this.actorCurIntensity = new Array[Double](size, (p:Int) => 0.0);
    }

    // initialize all actors to position within some bounding box
    def this(n:Int, r:Box, scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size);
        for (var i:Int = 0; i < size; i++) {
            this.pos(3*i) = r.l*rand.nextDouble() + r.v1(0);
            this.pos(3*i+1) = r.w*rand.nextDouble() + r.v1(1);
            this.pos(3*i+2) = r.h*rand.nextDouble();
        }

        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.scene = scene;
        this.acttype = ActorType.Firefly;
        this.actorFlashFreq = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));
        this.stepCount =  new Array[Int](size, (p:Int) => 0);
        this.actorFlashIntensity = new Array[Double](size, (p:Int) => maxValue*rand.nextDouble());
        this.actorCurIntensity = new Array[Double](size, (p:Int) => 0.0);
    }


    // initialize actors to positions given by array
    def this(n:Int, pos:Array[Double], scene:Scene) {
        this.size = n;
        this.pos = new Array[Double](3*size, (p:Int) => pos(p));
        this.health = new Array[Double](size, (p:Int) => 100.0);
        this.scene = scene;
        this.acttype = ActorType.Firefly;
        this.actorFlashFreq = new Array[Int](size, (p:Int) => rand.nextInt(maxValue));
        this.stepCount =  new Array[Int](size, (p:Int) => 0);
        this.actorFlashIntensity = new Array[Double](size, (p:Int) => maxValue*rand.nextDouble());
        this.actorCurIntensity = new Array[Double](size, (p:Int) => 0.0);
    }

    public def stepActors():void {
        for (var i:Int = 0; i < this.size; i++) {
            if (!this.alive(i))
                continue;
            
            // keep track of how many steps its been since we've flashed
            // then reset our intensity, and become less bright as time goes on.
            if (this.stepCount(i) == this.actorFlashFreq(i)) {
                this.stepCount(i) = 0;
                this.actorCurIntensity(i) = this.actorFlashFreq(i);
            }
            else {
                this.actorCurIntensity(i) = this.actorCurIntensity(i) - 1;
                this.stepCount(i) = this.stepCount(i) + 1;
                }

            // find out what other actors are around us
            var env:ArrayList[Pair[Int,Int]] = this.scene.actorQuery(this.pos(3*i), this.pos(3*i+1), this.pos(3*i+2), 2*maxValue*rand.nextDouble());

            // if there are no actors around us or we are at the hive try to spread out
            if (env.isEmpty() || ((this.pos(3*i) == 0.0) && (this.pos(3*i+1) == 0.0) && (this.pos(3*i+2) == 0.0))) {
                this.pos(3*i) += (2*maxValue*rand.nextDouble())-maxValue;
                this.pos(3*i+1) += (2*maxValue*rand.nextDouble())-maxValue;
                this.pos(3*i+2) += (2*maxValue*rand.nextDouble())-maxValue;
            } else { 
                // find the index of firefly group
                var fireflygroup:Int = -1;
                for (var j:Int = 0; j < this.scene.actorGroups.size; j++) {
                    if (this.scene.actorGroups(j).acttype == ActorType.Firefly) {
                        fireflygroup = j;
                        break;
                    }
                }
                if (fireflygroup != -1) {
                    // find a firefly with a current intensity that is bighter than ours and go near it.
                    var a:Int = this.envFind(fireflygroup, env, i);
                    if (a != -1) {                        
                        this.pos(3*i) = this.pos(3*a) + (rand.nextDouble()-1);
                        this.pos(3*i+1) = this.pos(3*a+1) + (rand.nextDouble()-1);
                        this.pos(3*i+2) = this.pos(3*a+2) + (rand.nextDouble()-1);
                    }
                    // otherwise just go somewhere else
                    else {
                        this.pos(3*i) += (2*maxValue*rand.nextDouble())-maxValue;
                        this.pos(3*i+1) += (2*maxValue*rand.nextDouble())-maxValue;
                        this.pos(3*i+2) += (2*maxValue*rand.nextDouble())-maxValue;
                    }                    
                } else {
                    // if we couldn't find the firefly group for some reason, just go somewhere.
                        this.pos(3*i) += (2*maxValue*rand.nextDouble())-maxValue;
                        this.pos(3*i+1) += (2*maxValue*rand.nextDouble())-maxValue;
                        this.pos(3*i+2) += (2*maxValue*rand.nextDouble())-maxValue;
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