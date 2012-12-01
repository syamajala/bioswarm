import x10.util.ArrayList;
import x10.util.Random;
import x10.util.concurrent.AtomicDouble;

// we happen to know how much of this affector will be in the scene at the start, so implemented with Array.
public class FoodGroup extends EnvAffectorGroup {
    var quantity:Array[AtomicDouble];

    def this(n:Int, rand:Random) {
        this.size = n;
        this.pos = new ArrayList[double](3*size);
        this.quantity = new Array[AtomicDouble](size, (p:Int) => new AtomicDouble(100.0));
        this.group_type = EnvAffectorType.Food;
        for (var i:Int = 0; i < 3*size; i++) {
            if (i%3 == 0) 
                pos.add(0.0);
            else
                pos.add(rand.nextInt(1000) as Double);
        }
	this.rand = rand;
    }

    def this(n:Int, r:Box, rand:Random) {
        this.size = n;
        this.pos = new ArrayList[Double](3*size);
        this.group_type = EnvAffectorType.Food;
        this.quantity = new Array[AtomicDouble](size, (p:Int) => new AtomicDouble(100.0));
        for (var i:Int = 0; i < size; i++) {

            var x:Double = rand.nextInt(r.l as Int) as Double + r.v1(0);
            var y:Double = rand.nextInt(r.w as Int) as Double + r.v1(1);

            while (!r.contained(x, y, 0)) {
                x = rand.nextInt(r.l as Int) as Double + r.v1(0);
                y = rand.nextInt(r.w as Int) as Double + r.v1(1);
            }

            this.pos.add(x);
            this.pos.add(y);
            this.pos.add(0);
        }        
        this.rand = rand;
    }

    def this(n:Int, p:Array[double]) {
        this.size = n;
        this.pos = new ArrayList[double](3*size);
        this.quantity = new Array[AtomicDouble](size, (p:Int) => new AtomicDouble(100.0));
        for (var i:Int = 0; i < p.size; i++)
            this.pos.add(p(i));
        this.group_type = EnvAffectorType.Food;
        
        Console.OUT.println("food group pos size: " + this.pos.size());
    }

    def available(i:int, chomp_size:double):Boolean {
        if (quantity(i).get() > chomp_size) 
            return true;
        else
            return false;
    }
    
    public def stepDynamicAttributes():void {
    	// TODO: auto-generated method stub
    }


}