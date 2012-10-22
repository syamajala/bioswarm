import x10.util.ArrayList;

public class FireGroup extends EnvAffectorGroup {

    def this(n:Int) {
        this.size = n;
        this.pos = new ArrayList[Double](3*size);
        this.group_type = EnvAffectorType.Fire;
        for (var i:Int = 0; i < 3*size; i++) {
            if (i%3 == 0) 
                this.pos.add(0.0);
            else
                this.pos.add(rand.nextInt(1000) as Double);
        }
    }

    def this(n:Int, r:Box) {
        this.size = n;
        this.pos = new ArrayList[Double](3*size);
        this.group_type = EnvAffectorType.Fire;

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
    }

    def this(n:Int, p:Array[Double]) {
        this.size = n;
        this.pos = new ArrayList[Double](3*size);
        for (var i:Int = 0; i < p.size; i++)
            this.pos.add(p(i));
        this.group_type = types.Fire;
    }
    
	public def stepDynamicAttributes():void {
	    // TODO: auto-generated method stub
	}


}