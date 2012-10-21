import x10.util.ArrayList;

public class FoodGroup extends EnvAffectorGroup {
    var quantity:Array[Double];

    def this(n:Int) {
        this.size = n;
        this.pos = new ArrayList[Double](3*size);
        for (var i:Int = 0; i < 3*size; i++) {
            if (i%3 == 0) 
                pos.add(0.0);
            else
                pos.add(rand.nextInt(1000) as Double);
        }

        this.quantity = new Array[Double](size, (p:Int) => 100.0);        
        this.afftype = types.Food;
    }    
}