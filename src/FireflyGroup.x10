import x10.util.ArrayList;
import x10.util.Pair;

public class FireflyGroup extends ActorGroup {
    var actorFlashFreq:Array[Int]; 
    var actorCurIntensity:Array[Double];
    var stepCount:Array[Int];
    var actorFlashIntensity:Array[Double];
    var fireflygroup:Int;

    // initialize position of all actors to hive location
    def this(n:Int, idx:Int, scene:Scene) {
        this.size = n;
        this.scene = scene;
        this.fireflygroup = idx;
        this.pos = new Array[Double](3*size, (p:Int) => 0.0);
        this.sharedinit();        
    }

    // initialize all actors to position within some bounding box
    def this(n:Int, r:Box, idx:Int, scene:Scene) {
        this.size = n;
        this.scene = scene;
        this.fireflygroup = idx;
        this.pos = new Array[Double](3*this.size);
        for (var i:Int = 0; i < this.size; i++) {
            this.pos(3*i) = r.l*rand.nextDouble() + r.v1(0);
            this.pos(3*i+1) = r.w*rand.nextDouble() + r.v1(1);
            this.pos(3*i+2) = r.h*rand.nextDouble();
        }
        this.sharedinit();
    }


    // initialize actors to positions given by array
    def this(n:Int, pos:Array[Double], idx:Int, scene:Scene) {
        this.size = n;
        this.scene = scene;
        this.fireflygroup = idx;
        this.pos = new Array[Double](3*size, (p:Int) => pos(p));
        this.sharedinit();
    }

    private def sharedinit() {
        this.health = new Array[Double](this.size, (p:Int) => 100.0);
        this.acttype = ActorType.Firefly;
        this.actorFlashFreq = new Array[Int](this.size, (p:Int) => rand.nextInt(maxValue));
        this.stepCount =  new Array[Int](this.size, (p:Int) => 0);
        this.actorFlashIntensity = new Array[Double](this.size, (p:Int) => maxValue*rand.nextDouble());
        this.actorCurIntensity = new Array[Double](this.size, (p:Int) => 0.0);        
    }

    public def serialstepActors():void {
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
                // find a firefly with a current intensity that is bighter than ours and go near it.
                var a:Int = this.envFind(this.fireflygroup, env, i);
                if (a != -1) {
                    this.pos(3*i) = this.pos(3*a) + ((5*maxValue*rand.nextDouble())-5*maxValue);
                    this.pos(3*i+1) = this.pos(3*a+1) + ((5*maxValue*rand.nextDouble())-5*maxValue);
                    this.pos(3*i+2) = this.pos(3*a+2) + ((5*maxValue*rand.nextDouble())-5*maxValue);
                }
                // otherwise just go somewhere else
                else {
                    this.pos(3*i) += (2*maxValue*rand.nextDouble())-maxValue;
                    this.pos(3*i+1) += (2*maxValue*rand.nextDouble())-maxValue;
                    this.pos(3*i+2) += (2*maxValue*rand.nextDouble())-maxValue;
                }                    
            }
        }
    }

    public def parallelstepActors():void {
        finish for (var ii:Int = 0; ii < this.size; ii++) {
            val i = ii;
            if (!this.alive(i))
                    continue;
            async {                               
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
                    this.pos(3*i) += ((2*maxValue*rand.nextDouble())-maxValue);
                    this.pos(3*i+1) += ((2*maxValue*rand.nextDouble())-maxValue);
                    this.pos(3*i+2) += ((2*maxValue*rand.nextDouble())-maxValue);
                } else { 
                    // find a firefly with a current intensity that is bighter than ours and go near it.
                    var a:Int = this.envFind(this.fireflygroup, env, i);
                    if (a != -1) {
                        this.pos(3*i) = this.pos(3*a) + ((5*maxValue*rand.nextDouble())-5*maxValue);
                        this.pos(3*i+1) = this.pos(3*a+1) + ((5*maxValue*rand.nextDouble())-5*maxValue);
                        this.pos(3*i+2) = this.pos(3*a+2) + ((5*maxValue*rand.nextDouble())-5*maxValue);
                    }
                    // otherwise just go somewhere else
                    else {
                        this.pos(3*i) += (2*maxValue*rand.nextDouble())-maxValue;
                        this.pos(3*i+1) += (2*maxValue*rand.nextDouble())-maxValue;
                        this.pos(3*i+2) += (2*maxValue*rand.nextDouble())-maxValue;
                    }       
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